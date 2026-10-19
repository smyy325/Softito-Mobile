#!/usr/bin/env bash
# ==============================================================================
# Script: generate_feture.sh
# Açıklama: Susadım Fitness & Su Takip projesi için standartlara tam uyumlu
#           modüler (feature-based) Flutter iskeleti oluşturma betiği.
#
# Standartlar:
#   - project.md ve SKILL.md kurallarına %100 uyum
#   - Reaktif Durum: ValueNotifier / ValueListenableBuilder (0 harici paket)
#   - Atomik Widget: < 40 satır build metotları, const yapıcılar
#   - Tema: Theme.of(context).colorScheme (Material 3 Dark/Light)
#   - Test: Saf Dart / Flutter Test birim test iskeleti
# ==============================================================================

set -euo pipefail

# Renkler (Terminal Çıktısı)
CLR_RESET="\033[0m"
CLR_BOLD="\033[1m"
CLR_GREEN="\033[32m"
CLR_BLUE="\033[34m"
CLR_YELLOW="\033[33m"
CLR_RED="\033[31m"
CLR_CYAN="\033[36m"

print_info()    { echo -e "${CLR_BLUE}[BİLGİ]${CLR_RESET} $1"; }
print_success() { echo -e "${CLR_GREEN}[BAŞARILI]${CLR_RESET} $1"; }
print_warn()    { echo -e "${CLR_YELLOW}[UYARI]${CLR_RESET} $1"; }
print_error()   { echo -e "${CLR_RED}[HATA]${CLR_RESET} $1"; }

show_help() {
  echo -e "${CLR_BOLD}Kullanım:${CLR_RESET}"
  echo -e "  ./generate_feture.sh [seçenekler] <ozellik_adi>"
  echo -e ""
  echo -e "${CLR_BOLD}Açıklama:${CLR_RESET}"
  echo -e "  Belirtilen özellik adıyla 'lib/features/<ozellik_adi>' altında standartlara uygun"
  echo -e "  controller, model, view, widget ve birim test dosyalarını üretir."
  echo -e ""
  echo -e "${CLR_BOLD}Argümanlar:${CLR_RESET}"
  echo -e "  <ozellik_adi>       snake_case formatında özellik adı (örn: water_tracker, workout, sleep_tracker)"
  echo -e ""
  echo -e "${CLR_BOLD}Seçenekler:${CLR_RESET}"
  echo -e "  -d, --dry-run       Dosyaları diske yazmadan yalnızca üretilecek yapıyı listeler."
  echo -e "  -f, --force         Varsa mevcut dosyaların üzerine yazar."
  echo -e "  -h, --help          Bu yardım iletisini görüntüler."
  echo -e ""
  echo -e "${CLR_BOLD}Örnekler:${CLR_RESET}"
  echo -e "  ./generate_feture.sh water_tracker"
  echo -e "  ./generate_feture.sh --dry-run workout"
}

# String Dönüştürücüler
to_pascal_case() {
  echo "$1" | awk -F_ '{for(i=1;i<=NF;i++) printf "%s", toupper(substr($i,1,1)) substr($i,2)}'
}

to_camel_case() {
  local p
  p=$(to_pascal_case "$1")
  local first
  first=$(echo "${p:0:1}" | tr '[:upper:]' '[:lower:]')
  echo "${first}${p:1}"
}

# Parametre Ayrıştırma
DRY_RUN=false
FORCE=false
FEATURE_INPUT=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      show_help
      exit 0
      ;;
    -d|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -f|--force)
      FORCE=true
      shift
      ;;
    -*)
      print_error "Bilinmeyen seçenek: $1"
      show_help
      exit 1
      ;;
    *)
      if [[ -z "$FEATURE_INPUT" ]]; then
        FEATURE_INPUT="$1"
      else
        print_error "Birden fazla özellik adı girilemez: $1"
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "$FEATURE_INPUT" ]]; then
  print_error "Özellik adı belirtilmelidir!"
  echo ""
  show_help
  exit 1
fi

# Özellik adını normalize et (küçük harf, tireleri alt çizgiye çevir)
FEATURE_NAME=$(echo "$FEATURE_INPUT" | tr '[:upper:]' '[:lower:]' | tr '-' '_')
CLASS_NAME=$(to_pascal_case "$FEATURE_NAME")
VAR_NAME=$(to_camel_case "$FEATURE_NAME")

# Hedef Yollar
FEATURE_DIR="lib/features/${FEATURE_NAME}"
TEST_DIR="test/features/${FEATURE_NAME}"

CONTROLLER_FILE="${FEATURE_DIR}/controller/${FEATURE_NAME}_controller.dart"
MODEL_FILE="${FEATURE_DIR}/models/${FEATURE_NAME}_model.dart"
VIEW_FILE="${FEATURE_DIR}/view/${FEATURE_NAME}_view.dart"
CARD_WIDGET_FILE="${FEATURE_DIR}/widget/${FEATURE_NAME}_summary_card.dart"
ACTIONS_WIDGET_FILE="${FEATURE_DIR}/widget/${FEATURE_NAME}_action_buttons.dart"
TEST_FILE="${TEST_DIR}/${FEATURE_NAME}_controller_test.dart"

echo -e "${CLR_CYAN}${CLR_BOLD}=== Susadım Feature Scaffold Üretici ===${CLR_RESET}"
echo -e "Özellik Adı:   ${CLR_BOLD}${FEATURE_NAME}${CLR_RESET}"
echo -e "Sınıf Adı:     ${CLR_BOLD}${CLASS_NAME}${CLR_RESET}"
echo -e "Hedef Dizin:   ${CLR_BOLD}${FEATURE_DIR}${CLR_RESET}"
echo ""

if [[ "$DRY_RUN" == true ]]; then
  print_info "Dry-run modu aktif. Üretilecek dosyalar:"
  echo "  - ${CONTROLLER_FILE}"
  echo "  - ${MODEL_FILE}"
  echo "  - ${VIEW_FILE}"
  echo "  - ${CARD_WIDGET_FILE}"
  echo "  - ${ACTIONS_WIDGET_FILE}"
  echo "  - ${TEST_FILE}"
  exit 0
fi

# Dizinleri Oluştur
mkdir -p "${FEATURE_DIR}/controller"
mkdir -p "${FEATURE_DIR}/models"
mkdir -p "${FEATURE_DIR}/view"
mkdir -p "${FEATURE_DIR}/widget"
mkdir -p "${TEST_DIR}"

write_file() {
  local target_path="$1"
  local content="$2"

  if [[ -f "$target_path" && "$FORCE" != true ]]; then
    print_warn "Dosya zaten mevcut, atlandı: ${target_path} (Üzerine yazmak için --force kullanın)"
    return
  fi

  echo "$content" > "$target_path"
  print_success "Oluşturuldu: ${target_path}"
}

# ------------------------------------------------------------------------------
# 1. MODEL DOSYASI
# ------------------------------------------------------------------------------
MODEL_CONTENT=$(cat << 'EOF'
import 'package:flutter/foundation.dart';

/// %CLASS_NAME% modülü için değişmez durum modeli.
/// Standartlar: @immutable, const yapıcı, copyWith, fromJson, toJson
@immutable
class %CLASS_NAME%Model {
  final String id;
  final String title;
  final int value;
  final DateTime updatedAt;

  const %CLASS_NAME%Model({
    required this.id,
    required this.title,
    required this.value,
    required this.updatedAt,
  });

  /// Varsayılan başlangıç durumu
  factory %CLASS_NAME%Model.initial() {
    return %CLASS_NAME%Model(
      id: 'default',
      title: '%CLASS_NAME% Takibi',
      value: 0,
      updatedAt: DateTime.now(),
    );
  }

  %CLASS_NAME%Model copyWith({
    String? id,
    String? title,
    int? value,
    DateTime? updatedAt,
  }) {
    return %CLASS_NAME%Model(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory %CLASS_NAME%Model.fromJson(Map<String, dynamic> json) {
    return %CLASS_NAME%Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      value: json['value'] as int? ?? 0,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is %CLASS_NAME%Model &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          value == other.value &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(id, title, value, updatedAt);
}
EOF
)
MODEL_CONTENT="${MODEL_CONTENT//%CLASS_NAME%/$CLASS_NAME}"
write_file "$MODEL_FILE" "$MODEL_CONTENT"

# ------------------------------------------------------------------------------
# 2. CONTROLLER DOSYASI
# ------------------------------------------------------------------------------
CONTROLLER_CONTENT=$(cat << 'EOF'
import 'package:flutter/foundation.dart';
import '../models/%FEATURE_NAME%_model.dart';

/// %CLASS_NAME% iş mantığı ve reaktif durum yöneticisi.
/// project.md Kuralı: Harici ağır state paketleri yerine ValueNotifier kullanılır.
class %CLASS_NAME%Controller {
  final ValueNotifier<%CLASS_NAME%Model> stateNotifier;

  %CLASS_NAME%Controller({%CLASS_NAME%Model? initialState})
      : stateNotifier = ValueNotifier<%CLASS_NAME%Model>(
          initialState ?? %CLASS_NAME%Model.initial(),
        );

  %CLASS_NAME%Model get state => stateNotifier.value;

  /// Değeri artırma eylemi
  void increment(int amount) {
    if (amount <= 0) return;
    stateNotifier.value = state.copyWith(
      value: state.value + amount,
      updatedAt: DateTime.now(),
    );
  }

  /// Değeri sıfırlama eylemi
  void reset() {
    stateNotifier.value = state.copyWith(
      value: 0,
      updatedAt: DateTime.now(),
    );
  }

  /// Başlığı güncelleme eylemi
  void updateTitle(String newTitle) {
    if (newTitle.trim().isEmpty) return;
    stateNotifier.value = state.copyWith(
      title: newTitle.trim(),
      updatedAt: DateTime.now(),
    );
  }

  /// Bellek sızıntılarını önlemek için dinleyiciyi kapat
  void dispose() {
    stateNotifier.dispose();
  }
}
EOF
)
CONTROLLER_CONTENT="${CONTROLLER_CONTENT//%CLASS_NAME%/$CLASS_NAME}"
CONTROLLER_CONTENT="${CONTROLLER_CONTENT//%FEATURE_NAME%/$FEATURE_NAME}"
write_file "$CONTROLLER_FILE" "$CONTROLLER_CONTENT"

# ------------------------------------------------------------------------------
# 3. ÖZEL WIDGET: SUMMARY CARD
# ------------------------------------------------------------------------------
CARD_CONTENT=$(cat << 'EOF'
import 'package:flutter/material.dart';
import '../models/%FEATURE_NAME%_model.dart';

/// %CLASS_NAME% özet gösterim kartı.
/// Standartlar: build metodu < 40 satır, Theme.of(context).colorScheme kullanımı, const yapıcı.
class %CLASS_NAME%SummaryCard extends StatelessWidget {
  final %CLASS_NAME%Model data;

  const %CLASS_NAME%SummaryCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data.value}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(Icons.bolt, color: colorScheme.primary, size: 36),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
EOF
)
CARD_CONTENT="${CARD_CONTENT//%CLASS_NAME%/$CLASS_NAME}"
CARD_CONTENT="${CARD_CONTENT//%FEATURE_NAME%/$FEATURE_NAME}"
write_file "$CARD_WIDGET_FILE" "$CARD_CONTENT"

# ------------------------------------------------------------------------------
# 4. ÖZEL WIDGET: ACTION BUTTONS
# ------------------------------------------------------------------------------
ACTIONS_CONTENT=$(cat << 'EOF'
import 'package:flutter/material.dart';

/// %CLASS_NAME% eylem butonları bileşeni.
/// Standartlar: build < 40 satır, const yapıcı, Material 3 uyumlu butonlar.
class %CLASS_NAME%ActionButtons extends StatelessWidget {
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  const %CLASS_NAME%ActionButtons({
    super.key,
    required this.onIncrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onIncrement,
            icon: const Icon(Icons.add),
            label: const Text('Artır'),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh),
          label: const Text('Sıfırla'),
        ),
      ],
    );
  }
}
EOF
)
ACTIONS_CONTENT="${ACTIONS_CONTENT//%CLASS_NAME%/$CLASS_NAME}"
write_file "$ACTIONS_WIDGET_FILE" "$ACTIONS_CONTENT"

# ------------------------------------------------------------------------------
# 5. VIEW DOSYASI
# ------------------------------------------------------------------------------
VIEW_CONTENT=$(cat << 'EOF'
import 'package:flutter/material.dart';
import '../controller/%FEATURE_NAME%_controller.dart';
import '../models/%FEATURE_NAME%_model.dart';
import '../widget/%FEATURE_NAME%_summary_card.dart';
import '../widget/%FEATURE_NAME%_action_buttons.dart';

/// %CLASS_NAME% ana ekran görünümü.
/// Standartlar: StatelessWidget, ValueListenableBuilder ile reaktif dinleme,
/// build metodu < 40 satır, modüler alt widget kullanımı.
class %CLASS_NAME%View extends StatefulWidget {
  const %CLASS_NAME%View({super.key});

  @override
  State<%CLASS_NAME%View> createState() => _%CLASS_NAME%ViewState();
}

class _%CLASS_NAME%ViewState extends State<%CLASS_NAME%View> {
  late final %CLASS_NAME%Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = %CLASS_NAME%Controller();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('%CLASS_NAME%'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ValueListenableBuilder<%CLASS_NAME%Model>(
            valueListenable: _controller.stateNotifier,
            builder: (context, state, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  %CLASS_NAME%SummaryCard(data: state),
                  const Spacer(),
                  %CLASS_NAME%ActionButtons(
                    onIncrement: () => _controller.increment(10),
                    onReset: _controller.reset,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
EOF
)
VIEW_CONTENT="${VIEW_CONTENT//%CLASS_NAME%/$CLASS_NAME}"
VIEW_CONTENT="${VIEW_CONTENT//%FEATURE_NAME%/$FEATURE_NAME}"
write_file "$VIEW_FILE" "$VIEW_CONTENT"

# ------------------------------------------------------------------------------
# 6. BİRİM TEST DOSYASI
# ------------------------------------------------------------------------------
TEST_CONTENT=$(cat << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:%APP_NAME%/features/%FEATURE_NAME%/controller/%FEATURE_NAME%_controller.dart';
import 'package:%APP_NAME%/features/%FEATURE_NAME%/models/%FEATURE_NAME%_model.dart';

void main() {
  group('%CLASS_NAME%Controller Testleri', () {
    late %CLASS_NAME%Controller controller;

    setUp(() {
      controller = %CLASS_NAME%Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumu varsayılan değerleri içermelidir', () {
      expect(controller.state, isA<%CLASS_NAME%Model>());
      expect(controller.state.value, 0);
      expect(controller.state.title, '%CLASS_NAME% Takibi');
    });

    test('increment pozitif değer aldığında state güncellenmelidir', () {
      controller.increment(15);
      expect(controller.state.value, 15);

      controller.increment(5);
      expect(controller.state.value, 20);
    });

    test('increment sıfır veya negatif değerlerde state değişmemelidir', () {
      controller.increment(0);
      expect(controller.state.value, 0);

      controller.increment(-10);
      expect(controller.state.value, 0);
    });

    test('reset metodu değeri sıfıra indirmelidir', () {
      controller.increment(50);
      expect(controller.state.value, 50);

      controller.reset();
      expect(controller.state.value, 0);
    });
  });
}
EOF
)
# Package adı tespit etmeye çalış
APP_NAME="susadim"
if [[ -f "pubspec.yaml" ]]; then
  DETECTED_NAME=$(grep -E '^name:' pubspec.yaml | head -n1 | awk '{print $2}' | tr -d '\r\n')
  if [[ -n "$DETECTED_NAME" ]]; then
    APP_NAME="$DETECTED_NAME"
  fi
fi

TEST_CONTENT="${TEST_CONTENT//%CLASS_NAME%/$CLASS_NAME}"
TEST_CONTENT="${TEST_CONTENT//%FEATURE_NAME%/$FEATURE_NAME}"
TEST_CONTENT="${TEST_CONTENT//%APP_NAME%/$APP_NAME}"
write_file "$TEST_FILE" "$TEST_CONTENT"

echo ""
print_success "'${FEATURE_NAME}' modülü başarıyla oluşturuldu!"
echo ""
echo -e "${CLR_BOLD}Doğrulama Adımları:${CLR_RESET}"
echo -e "Şimdi Flutter analiz ile kontrol edebilirsin:"
echo -e "  ${CLR_CYAN}flutter analyze${CLR_RESET}"
echo -e "  ${CLR_CYAN}flutter test ${TEST_FILE}${CLR_RESET}"
echo ""
