import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studypad_mobile/main.dart';

void main() {
  group('StudyPad App Tests', () {
    testWidgets('App launches and shows home screen', (WidgetTester tester) async {
      // Build the app and trigger a frame
      await tester.pumpWidget(const StudyPadApp());

      // Verify the app title is displayed
      expect(find.text('StudyPad'), findsOneWidget);

      // Verify navigation bar items are present
      expect(find.text('Documents'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Studio'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Navigation between tabs works', (WidgetTester tester) async {
      await tester.pumpWidget(const StudyPadApp());

      // Start on Documents tab
      expect(find.text('No documents yet'), findsOneWidget);

      // Tap on Chat tab
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();

      // Verify Chat screen is shown
      expect(find.text('Chat with your documents'), findsOneWidget);

      // Tap on Studio tab
      await tester.tap(find.text('Studio'));
      await tester.pumpAndSettle();

      // Verify Studio screen is shown
      expect(find.text('AI Studio'), findsOneWidget);

      // Tap on Settings tab
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify Settings screen is shown
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('Upload button appears on Documents tab', (WidgetTester tester) async {
      await tester.pumpWidget(const StudyPadApp());

      // Verify upload button is present on Documents tab
      expect(find.widgetWithIcon(FloatingActionButton, Icons.upload_file), findsOneWidget);
      expect(find.text('Upload'), findsOneWidget);
    });

    testWidgets('Upload button disappears on other tabs', (WidgetTester tester) async {
      await tester.pumpWidget(const StudyPadApp());

      // Navigate to Chat tab
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();

      // Verify upload button is not present
      expect(find.widgetWithIcon(FloatingActionButton, Icons.upload_file), findsNothing);
    });

    testWidgets('Upload button shows coming soon message', (WidgetTester tester) async {
      await tester.pumpWidget(const StudyPadApp());

      // Tap the upload button
      await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.upload_file));
      await tester.pump();

      // Verify snackbar message is shown
      expect(find.text('Upload feature coming soon!'), findsOneWidget);
    });

    testWidgets('Debug info button appears in debug mode', (WidgetTester tester) async {
      await tester.pumpWidget(const StudyPadApp());

      // In debug mode, the info button should be present
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });
}
