import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../data/roulette_repository.dart';
import '../../../data/templates_data.dart';
import '../widgets/template_card.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('템플릿')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: kTemplates.length,
        itemBuilder: (context, i) {
          final template = kTemplates[i];
          return TemplateCard(
            template: template,
            onTap: () => _showDetailSheet(context, template),
          );
        },
      ),
    );
  }

  void _showDetailSheet(
    BuildContext context,
    Map<String, dynamic> template,
  ) {
    final items = (template['items'] as List<dynamic>).cast<String>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, scrollCtrl) => Column(
          children: [
            // 핸들
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Text(
                    template['emoji'] as String,
                    style: const TextStyle(fontSize: 36),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template['name'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${template['category']} · ${items.length}개 항목',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            // 항목 목록
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                itemCount: items.length,
                itemBuilder: (_, i) => ListTile(
                  leading: CircleAvatar(
                    radius: 14,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  title: Text(items[i]),
                ),
              ),
            ),
            // 사용 버튼
            Padding(
              padding: EdgeInsets.fromLTRB(
                24, 12, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('이 템플릿 사용'),
                  onPressed: () => _useTemplate(ctx, context, template, items),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _useTemplate(
    BuildContext sheetCtx,
    BuildContext screenCtx,
    Map<String, dynamic> template,
    List<String> items,
  ) async {
    final repo = RouletteRepository.instance;
    final canCreate = await repo.canCreate();

    if (!canCreate) {
      if (sheetCtx.mounted) Navigator.of(sheetCtx).pop();
      if (screenCtx.mounted) {
        showModalBottomSheet(
          context: screenCtx,
          builder: (ctx) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48),
                const SizedBox(height: 16),
                Text(
                  '무료 플랜은 최대 ${AppLimits.maxRouletteCount}개까지 가능합니다',
                  style: Theme.of(screenCtx).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('닫기'),
                ),
              ],
            ),
          ),
        );
      }
      return;
    }

    if (sheetCtx.mounted) Navigator.of(sheetCtx).pop();
    if (screenCtx.mounted) {
      Navigator.of(screenCtx).pushNamed(
        AppRoutes.editor,
        // 템플릿 항목을 사전 입력 — arguments로 Map 전달
        arguments: {'templateName': template['name'], 'templateItems': items},
      );
    }
  }
}
