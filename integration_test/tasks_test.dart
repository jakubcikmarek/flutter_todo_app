import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:todo_app/widgets/todo_list_tile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    const disabled = true;
  testWidgets('add, edit, and delete todo', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Add a new todo
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'New Todo');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();


    // Verify the todo is added
    expect(find.text('New Todo'), findsOneWidget);

    expect(find.descendant(of: find.byType(CircleAvatar).at(0), matching: find.text("1")),findsOneWidget);
    expect(find.descendant(of: find.byType(CircleAvatar).at(1), matching: find.text("0")),findsOneWidget);

    expect(find.byType(TodoListTile), findsOneWidget);
    // touch the uncompleted task

    await tester.tap(find.byType(TodoListTile));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Edited Todo');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    // Verify the todo is updated

    expect(find.text('Edited Todo'), findsOneWidget);
    final todoListTile = find.byType(TodoListTile);
    final checkbox = find.descendant(of: todoListTile, matching: find.byType(Checkbox));
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(CircleAvatar).at(0), matching: find.text("0")),findsOneWidget);
    expect(find.descendant(of: find.byType(CircleAvatar).at(1), matching: find.text("1")),findsOneWidget);


    expect(find.descendant(of: todoListTile, matching: find.byType(ListTile)), findsOneWidget);
    await tester.tap(find.byIcon(Icons.keyboard_arrow_up).last);
    await tester.pumpAndSettle();
    expect(find.descendant(of: todoListTile, matching: find.byType(ListTile)), findsNothing);
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down).last);
    await tester.pumpAndSettle();
    expect(find.descendant(of: todoListTile, matching: find.byType(ListTile)), findsOneWidget);

    //move completed task back to remaining tasks

    final todoListTile2 = find.byType(TodoListTile).last;
    final checkbox2 = find.descendant(of: todoListTile2, matching: find.byType(Checkbox));
    await tester.tap(checkbox2);
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(CircleAvatar).at(0), matching: find.text("1")),findsOneWidget);
  },skip: disabled);

  testWidgets("enter long text", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'a' * 3000);
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('a' * 3000), findsOneWidget);
  },skip: disabled);
}
