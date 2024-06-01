import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:todo_app/screens/collections/common/collection_todo_list_tile.dart';
import 'package:todo_app/widgets/todo_list_tile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const collectionName = 'New Collection';
  testWidgets('add, edit, and delete collection', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DrawerButtonIcon));

    await tester.pumpAndSettle();
    // expect(find.text(displayName), findsOneWidget);

    // Find the NavigationDrawerDestination that represents the 'Collections' option
    final collectionsOption = find.byKey(const Key('navigation_collections'));
    expect(collectionsOption, findsOneWidget);
    await tester.tap(collectionsOption);
    await tester.pumpAndSettle();

    // Verify the collections screen is displayed
    expect(find.text('My Collections'), findsOneWidget);

    //check that there are no collections
    expect(find.byType(ListTile), findsNothing);

    // Add a new collection
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), collectionName);
    await tester.tap(find.byKey(const Key('create_collection_button')));
    await tester.pumpAndSettle();

    // Verify the collection is added
    final collectionTile = find.byType(ListTile);
    expect(collectionTile, findsOneWidget);

    //enter the collection details screen
    await tester.tap(collectionTile);
    await tester.pumpAndSettle();

    // Verify the collection details screen is displayed
    expect(find.text(collectionName), findsOneWidget);

    // Edit the collection name
    const newCollectionName = 'New Collection Name';
    await tester.tap(find.byKey(const Key('edit_collection_button')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), newCollectionName);
    await tester.tap(find.byKey(const Key('edit_collection_button_submit')));
    await tester.pumpAndSettle();

    // Verify the collection name is updated
    expect(find.text(newCollectionName), findsOneWidget);

    // add a task to the collection
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'New Task');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    // Verify the task is added
    expect(
        find.descendant(
            of: find.byType(CircleAvatar).at(0), matching: find.text("1")),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(CircleAvatar).at(1), matching: find.text("0")),
        findsOneWidget);
    expect(find.byType(CollectionTodoListTile), findsOneWidget);

    // edit the task
    await tester.tap(find.byType(CollectionTodoListTile));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Edited Task');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    // Verify the task is updated
    expect(find.text('Edited Task'), findsOneWidget);

    // mark the task as completed
    final todoListTile = find.byType(CollectionTodoListTile);
    final checkbox =
        find.descendant(of: todoListTile, matching: find.byType(Checkbox));
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // Verify the task is marked as completed
    expect(
        find.descendant(
            of: find.byType(CircleAvatar).at(0), matching: find.text("0")),
        findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(CircleAvatar).at(1), matching: find.text("1")),
        findsOneWidget);

    // delete collection
    await tester.tap(find.byKey(const Key('edit_collection_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('delete_collection_button')));
    await tester.pumpAndSettle();

    //Verify the collection is deleted
    expect(find.byType(ListTile), findsNothing);
  });
}
