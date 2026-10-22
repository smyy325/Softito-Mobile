import os
import math
import zlib
import struct

def make_png(width, height, pixel_data):
    raw = bytearray()
    row_bytes = width * 4
    for y in range(height):
        raw.append(0)
        start = y * row_bytes
        raw.extend(pixel_data[start:start + row_bytes])
    
    def chunk(chunk_type, data):
        c = chunk_type + data
        crc = zlib.crc32(c) & 0xffffffff
        return struct.pack('>I', len(data)) + c + struct.pack('>I', crc)
    
    png = bytearray(b'\x89PNG\r\n\x1a\n')
    ihdr = struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0)
    png.extend(chunk(b'IHDR', ihdr))
    png.extend(chunk(b'IDAT', zlib.compress(bytes(raw), 9)))
    png.extend(chunk(b'IEND', b''))
    return bytes(png)

def clamp(v, low=0, high=255):
    return max(low, min(high, int(v)))

def generate_planet(filename, c_base, c_highlight, c_shadow, has_rings=False, ring_color=None, bands=True):
    width, height = 280, 280
    cx, cy = 140.0, 140.0
    r = 82.0 # Planet radius
    pixels = bytearray(width * height * 4)

    # Işık yönü
    lx, ly, lz = -0.55, -0.62, 0.55
    l_len = math.sqrt(lx*lx + ly*ly + lz*lz)
    lx, ly, lz = lx/l_len, ly/l_len, lz/l_len

    # Bakış yönü (0, 0, 1) - Specular hesaplama için
    ring_r_in = 96.0
    ring_r_out = 136.0

    for y in range(height):
        for x in range(width):
            idx = (y * width + x) * 4
            dx = x - cx
            dy = y - cy
            dist = math.sqrt(dx*dx + dy*dy)

            # 1. Dış Atmosferik Parıltı (Outer Corona Glow)
            if r < dist <= r + 18.0:
                glow_t = 1.0 - (dist - r) / 18.0
                glow_val = math.pow(glow_t, 2.0) * 0.55
                pixels[idx] = clamp(c_highlight[0] * glow_val)
                pixels[idx+1] = clamp(c_highlight[1] * glow_val)
                pixels[idx+2] = clamp(c_highlight[2] * glow_val)
                pixels[idx+3] = clamp(glow_val * 255)

            # 2. Gezegen Küresi
            elif dist <= r:
                nx = dx / r
                ny = dy / r
                nz = math.sqrt(max(0.0, 1.0 - nx*nx - ny*ny))

                dot = nx * lx + ny * ly + nz * lz
                diffuse = max(0.0, dot)

                # Speküler yansıma (3D pürüzsüz parlaklık)
                # Yarım vektör h = (l + v) / |l + v| where v=(0,0,1)
                hx, hy, hz = lx, ly, lz + 1.0
                hlen = math.sqrt(hx*hx + hy*hy + hz*hz)
                hx, hy, hz = hx/hlen, hy/hlen, hz/hlen
                ndoth = max(0.0, nx*hx + ny*hy + nz*hz)
                specular = math.pow(ndoth, 24.0) * 0.65

                # Yüzey desenleri / bulut dalgaları
                band_factor = 1.0
                if bands:
                    band_val = math.sin(ny * 9.5 + math.sin(nx * 5.0) * 0.65)
                    band_factor = 0.82 + 0.35 * (0.5 + 0.5 * band_val)

                if diffuse > 0.45:
                    t = (diffuse - 0.45) / 0.55
                    red = (c_base[0] * (1-t) + c_highlight[0] * t) * band_factor
                    green = (c_base[1] * (1-t) + c_highlight[1] * t) * band_factor
                    blue = (c_base[2] * (1-t) + c_highlight[2] * t) * band_factor
                else:
                    t = diffuse / 0.45
                    red = (c_shadow[0] * (1-t) + c_base[0] * t) * band_factor
                    green = (c_shadow[1] * (1-t) + c_base[1] * t) * band_factor
                    blue = (c_shadow[2] * (1-t) + c_base[2] * t) * band_factor

                # Atmosfer kenar ışıltısı (Rim glow)
                rim = 1.0 - nz
                rim_glow = math.pow(rim, 2.6) * 0.75
                red = red * (1 - rim_glow) + c_highlight[0] * rim_glow
                green = green * (1 - rim_glow) + c_highlight[1] * rim_glow
                blue = blue * (1 - rim_glow) + c_highlight[2] * rim_glow

                # Speküler nokta ekle
                red += 255 * specular
                green += 255 * specular
                blue += 255 * specular

                # Yumuşak kenar (Antialiasing)
                edge = r - dist
                alpha = max(0.0, min(1.0, edge))

                pixels[idx] = clamp(red)
                pixels[idx+1] = clamp(green)
                pixels[idx+2] = clamp(blue)
                pixels[idx+3] = clamp(alpha * 255)

            # 3. Satürn ve Uranüs için Kozmik Halkalar
            if has_rings:
                angle = -0.42
                cos_a = math.cos(angle)
                sin_a = math.sin(angle)
                rx = dx * cos_a - dy * sin_a
                ry = (dx * sin_a + dy * cos_a) * 2.9

                rdist = math.sqrt(rx*rx + ry*ry)
                if ring_r_in <= rdist <= ring_r_out:
                    ring_t = (rdist - ring_r_in) / (ring_r_out - ring_r_in)
                    ring_alpha = math.sin(ring_t * math.pi) * 0.88
                    if 0.44 < ring_t < 0.54:
                        ring_alpha *= 0.2 # Cassini boşluğu

                    is_behind = (dx * sin_a + dy * cos_a) < 0
                    if not (is_behind and dist < r):
                        cr, cg, cb = ring_color
                        cur_a = pixels[idx+3] / 255.0
                        new_a = ring_alpha + cur_a * (1.0 - ring_alpha)
                        if new_a > 0.001:
                            pixels[idx] = clamp((cr * ring_alpha + pixels[idx] * cur_a * (1 - ring_alpha)) / new_a)
                            pixels[idx+1] = clamp((cg * ring_alpha + pixels[idx+1] * cur_a * (1 - ring_alpha)) / new_a)
                            pixels[idx+2] = clamp((cb * ring_alpha + pixels[idx+2] * cur_a * (1 - ring_alpha)) / new_a)
                            pixels[idx+3] = clamp(new_a * 255)

    png_data = make_png(width, height, bytes(pixels))
    with open(filename, 'wb') as f:
        f.write(png_data)

planets = [
    {
        "name": "planet_neptune.png",
        "base": (25, 120, 255),
        "highlight": (145, 230, 255),
        "shadow": (10, 30, 95),
        "rings": False,
        "ring_color": None,
        "bands": True
    },
    {
        "name": "planet_mars.png",
        "base": (255, 65, 40),
        "highlight": (255, 180, 115),
        "shadow": (120, 15, 10),
        "rings": False,
        "ring_color": None,
        "bands": True
    },
    {
        "name": "planet_jupiter.png",
        "base": (255, 155, 35),
        "highlight": (255, 235, 155),
        "shadow": (145, 60, 10),
        "rings": False,
        "ring_color": None,
        "bands": True
    },
    {
        "name": "planet_saturn.png",
        "base": (185, 120, 235),
        "highlight": (240, 215, 255),
        "shadow": (80, 35, 120),
        "rings": True,
        "ring_color": (225, 195, 255),
        "bands": True
    },
    {
        "name": "planet_earth.png",
        "base": (35, 180, 145),
        "highlight": (115, 245, 205),
        "shadow": (10, 70, 60),
        "rings": False,
        "ring_color": None,
        "bands": True
    },
    {
        "name": "planet_uranus.png",
        "base": (25, 220, 240),
        "highlight": (185, 255, 255),
        "shadow": (10, 95, 115),
        "rings": True,
        "ring_color": (160, 245, 255),
        "bands": False
    },
    {
        "name": "planet_venus.png",
        "base": (255, 100, 160),
        "highlight": (255, 210, 235),
        "shadow": (135, 25, 80),
        "rings": False,
        "ring_color": None,
        "bands": True
    },
    {
        "name": "planet_mercury.png",
        "base": (195, 180, 175),
        "highlight": (255, 245, 240),
        "shadow": (85, 75, 70),
        "rings": False,
        "ring_color": None,
        "bands": False
    },
]

dirs = [
    "/Users/sumeyye/modumGalaxy/assets/images/planets",
    "/Users/sumeyye/modumGalaxy/lib/assets/images/planets"
]

for d in dirs:
    os.makedirs(d, exist_ok=True)
    for p in planets:
        target = os.path.join(d, p["name"])
        generate_planet(
            target,
            c_base=p["base"],
            c_highlight=p["highlight"],
            c_shadow=p["shadow"],
            has_rings=p["rings"],
            ring_color=p["ring_color"],
            bands=p["bands"]
        )

print("All enhanced glowing planets generated successfully!")
