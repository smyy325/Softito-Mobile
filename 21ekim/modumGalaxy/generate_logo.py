import os
import math
from generate_planets import make_png, clamp

def generate_logo(filename):
    width, height = 256, 256
    cx, cy = 128.0, 128.0
    pixels = bytearray(width * height * 4)

    # A cosmic badge with a central glowing planet and orbiting star rings
    for y in range(height):
        for x in range(width):
            idx = (y * width + x) * 4
            dx = x - cx
            dy = y - cy
            dist = math.sqrt(dx*dx + dy*dy)

            # Outer celestial glow
            if dist <= 120:
                glow = math.pow(1.0 - (dist / 120.0), 1.8) * 0.25
                pixels[idx] = clamp(130 * glow)
                pixels[idx+1] = clamp(90 * glow)
                pixels[idx+2] = clamp(230 * glow)
                pixels[idx+3] = clamp(glow * 255)

            # Planetary core (r=55)
            r = 52.0
            if dist <= r:
                nx = dx / r
                ny = dy / r
                nz = math.sqrt(max(0.0, 1.0 - nx*nx - ny*ny))
                dot = max(0.0, -0.5 * nx - 0.6 * ny + 0.62 * nz)
                light = 0.25 + 0.75 * dot

                # Nebula purple to cyan gradient
                t = (ny + 1.0) / 2.0
                cr = (145 * (1 - t) + 40 * t) * light
                cg = (80 * (1 - t) + 210 * t) * light
                cb = (255 * (1 - t) + 245 * t) * light

                # Rim glow
                rim = math.pow(1.0 - nz, 2.5) * 0.7
                cr = cr * (1 - rim) + 220 * rim
                cg = cg * (1 - rim) + 240 * rim
                cb = cb * (1 - rim) + 255 * rim

                edge = r - dist
                alpha = max(0.0, min(1.0, edge))
                pixels[idx] = clamp(cr)
                pixels[idx+1] = clamp(cg)
                pixels[idx+2] = clamp(cb)
                pixels[idx+3] = clamp(alpha * 255)

            # Golden orbital ring
            angle = -0.5
            cos_a = math.cos(angle)
            sin_a = math.sin(angle)
            rx = dx * cos_a - dy * sin_a
            ry = (dx * sin_a + dy * cos_a) * 3.2
            rdist = math.sqrt(rx*rx + ry*ry)
            if 66 <= rdist <= 90:
                ring_t = (rdist - 66.0) / 24.0
                ring_alpha = math.sin(ring_t * math.pi) * 0.95
                is_behind = (dx * sin_a + dy * cos_a) < 0
                if not (is_behind and dist < r):
                    cur_a = pixels[idx+3] / 255.0
                    new_a = ring_alpha + cur_a * (1.0 - ring_alpha)
                    if new_a > 0.001:
                        pixels[idx] = clamp((255 * ring_alpha + pixels[idx] * cur_a * (1 - ring_alpha)) / new_a)
                        pixels[idx+1] = clamp((215 * ring_alpha + pixels[idx+1] * cur_a * (1 - ring_alpha)) / new_a)
                        pixels[idx+2] = clamp((90 * ring_alpha + pixels[idx+2] * cur_a * (1 - ring_alpha)) / new_a)
                        pixels[idx+3] = clamp(new_a * 255)

    png_data = make_png(width, height, bytes(pixels))
    with open(filename, 'wb') as f:
        f.write(png_data)

for d in ["assets/images", "lib/assets/images"]:
    os.makedirs(d, exist_ok=True)
    generate_logo(os.path.join(d, "app_logo.png"))
    print(f"Generated logo in {d}")
