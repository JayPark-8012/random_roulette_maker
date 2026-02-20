# Random Roulette Maker - Claude Working Agreement

## Goal (MVP Stage 2)
- Local-only roulette app (no server)
- Free: max 3 roulettes
- History: keep last 20 per roulette
- Screens: Splash, Home, Editor, Play, Templates, Settings
- State mgmt: ChangeNotifier / ValueNotifier only (NO Riverpod/BLoC)

## Project Structure (DO NOT CHANGE)
- lib/app.dart
- lib/main.dart
- lib/core/
- lib/data/
- lib/domain/
- lib/features/{home,editor,play,templates,settings}/(ui,state,widgets)

## Rules (token saving + quality)
- Before coding, read existing files and list EXACT files to change.
- Make minimal diffs. Do not refactor unrelated code.
- Do not add new packages unless explicitly requested.
- Never rewrite whole files if small patch is enough.
- Prefer "edit existing code" over "create new architecture".
- For each task: 1) plan in 5 bullets max, 2) implement, 3) give manual test steps.
- Keep comments short. Avoid long explanations.
- If something is unclear, choose the simplest MVP assumption and proceed.

## Data Model (fixed)
- Roulette: id, title(max30), items[], createdAt, updatedAt
- Item: label(max20), weight(default 1), colorIndex
- Settings: soundOn, hapticOn, spinSpeed, lastUsedRouletteId
- History: rouletteId, resultLabel, timestamp
- Limit: keep last 20 history entries per roulette

## UX constraints
- Prevent save if items < 2 or any empty label
- On free limit reached: show premium dialog (no purchase integration yet)