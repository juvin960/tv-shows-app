import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows_appp/Features/model/show_model.dart';
import 'package:tv_shows_appp/Features/presentation/view/show_list_screen.dart';
import 'package:tv_shows_appp/Features/presentation/view_model/show_view_model.dart';

import 'shows_page_test.mocks.dart';

  @GenerateMocks([ShowViewModel])
void main() {
  //Declares a variable in the mockViewModel that will be initialized later but
  // not at declaration.
  late MockShowViewModel mockViewModel;

  // setup runs before every test to get fresh mock each time
  setUp(() {
    mockViewModel = MockShowViewModel();
  });

  /// each test follows three steps:
  /// Arrange, define the behaviour of the mock.
  /// Act, build the widget and inject the mock.
  /// Assert, verify the ui reflects the mock.



  // Test 1: "No results found" + Refresh button
  testWidgets("Shows 'No results found' when list is empty",
          (WidgetTester tester) async {
        // Arrange: empty shows list
        when(mockViewModel.shows).thenReturn([]);
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);

        // Act: Build widget with Provider
        await tester.pumpWidget(
          ChangeNotifierProvider<ShowViewModel>.value(
            value: mockViewModel,
            child: const MaterialApp(home: HomePage()),
          ),
        );

        await tester.pump(); // Trigger rebuild

        // Assert: No results text + refresh button
        expect(find.text("No results found"), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });


  // Test 2: Shows loading indicator when isLoading = true
  testWidgets("Displays loading indicator when isLoading is true",
          (tester) async {

        //Arrange
        when(mockViewModel.isLoading).thenReturn(true);
        when(mockViewModel.shows).thenReturn([]);
        when(mockViewModel.errorMessage).thenReturn(null);

        //Act
        await tester.pumpWidget(
          ChangeNotifierProvider<ShowViewModel>.value(
            value: mockViewModel,
            child: const MaterialApp(home: HomePage()),
          ),
        );

        //Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  //Test 3: Displaying error message when error message is not null.

  testWidgets("Displays error message when errorMessage is not null",
          (tester) async {
        // Arrange
        when(mockViewModel.errorMessage).thenReturn("Something went wrong");
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.shows).thenReturn([]);

        // Act
        await tester.pumpWidget(
          ChangeNotifierProvider<ShowViewModel>.value(
            value: mockViewModel,
            child: const MaterialApp(home: HomePage()),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text("Something went wrong"), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });
  //Test 4: Typing in search trigger search method

  testWidgets("Typing in search triggers search method",
          (tester) async {
        // Arrange
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.shows).thenReturn([]);

        await tester.pumpWidget(
          ChangeNotifierProvider<ShowViewModel>.value(
            value: mockViewModel,
            child: const MaterialApp(home: HomePage()),
          ),
        );

        await tester.pumpAndSettle();

        final searchField = find.byType(TextField);


        await tester.enterText(searchField, "Friends");
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        verify(mockViewModel.search("Friends")).called(1);
        // SnackBar appears
        expect(find.text("Searching..."), findsOneWidget);
      });

  testWidgets("Displays shows in GridView", (tester) async {
    final mockShow = ShowModel(
      name: "Friends",
      ratings: "9.5",
      image: null,
      id: 0,
      summary: '',
      genreList: [],
      status: '',
      premiereDate: '',
      time: '',
      network: '',
      daysList: [],
      genreNames: 'Comedy',
    );

    when(mockViewModel.shows).thenReturn([mockShow]);
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.errorMessage).thenReturn(null);

    await tester.pumpWidget(
      ChangeNotifierProvider<ShowViewModel>.value(
        value: mockViewModel,
        child: const MaterialApp(home: HomePage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Friends"), findsOneWidget);
    expect(find.text("Comedy"), findsOneWidget);
  });


  }

