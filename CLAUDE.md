# CLAUDE.md - Touhou Labyrinth 2 Save Editor

## Commands
- Build: `flutter build`
- Run app: `flutter run`
- Format code: `dartformat .` (custom formatter, not standard `dart format`)
- Lint: `dart analyze`
- Run tests: `flutter test`
- Run single test: `flutter test example/test/widget_test.dart`

## Code Style Guidelines
- **Imports**: Always use package imports (`always_use_package_imports: true`)
- **Types**: Explicitly specify types (`always_specify_types: true`)
- **Strings**: Use single quotes for strings (`prefer_single_quotes: true`)
- **Variables**: Local variables should NOT be marked as final (`unnecessary_final`)
- **Line Length**: Keep lines under 80 characters
- **Formatting**: Use trailing commas for multi-line expressions
- **Parameters**: Put required named parameters first
- **Control Flow**: Always put control body on new line
- **Error Handling**: Only throw Error objects, use try/catch appropriately
- **Naming**: Follow Flutter/Dart conventions (camelCase for variables/methods, PascalCase for classes)

## Project Structure
- `lib/` - Main source code
  - `extensions/` - Dart extension methods
  - `mixins/` - Reusable mixins
  - `save/` - Save file data models
  - `views/` - UI screens
  - `widgets/` - Reusable UI components