import 'package:flutter_test/flutter_test.dart';

import 'package:uic/stateful_data/loadable_uic.dart';

void main() {
  setUp(() {
  });
  group('StatefulData loader', () {
    var listenerCallCount;
    setUp(() {
      listenerCallCount = 0;
    });
    test('Empty data', () async {
      final Future<String?> Function() loader = () async {
        await Future.delayed(Duration(seconds: 1));
        return null;
      };
      final data = StatefulData<String>(loader: loader);
      expect(data.isLoading, true);
      expect(data.state, StatefulDataState.initialLoading);
      data.addListener(() {
        expect(listenerCallCount, 0);
        expect(data.isLoading, false);
        expect(data.state, StatefulDataState.empty);
        listenerCallCount++;
      });
      await Future.delayed(Duration(seconds: 1));
    });
    test('Not empty data', () async {
      final Future<String?> Function() loader = () async {
        await Future.delayed(Duration(seconds: 1));
        return 'One';
      };
      final data = StatefulData<String>(loader: loader);
      expect(data.isLoading, true);
      expect(data.state, StatefulDataState.initialLoading);
      data.addListener(() {
        expect(listenerCallCount, 0);
        expect(data.isLoading, false);
        expect(data.state, StatefulDataState.ready);
        expect(data.data, 'One');
        listenerCallCount++;
      });
      await Future.delayed(Duration(seconds: 1));
    });
    test('Refresh data', () async {
      final Future<String?> Function() loader = () async {
        await Future.delayed(Duration(seconds: 1));
        if (listenerCallCount == 0) {
          return 'One';
        }
        else {
          return 'Two';
        }
      };
      final data = StatefulData<String>(loader: loader);
      expect(data.isLoading, true);
      expect(data.state, StatefulDataState.initialLoading);
      data.addListener(() {
        if (listenerCallCount == 0) {
          expect(data.isLoading, false);
          expect(data.state, StatefulDataState.ready);
          expect(data.data, 'One');
        }
        else if (listenerCallCount == 1) {
          expect(data.isLoading, true);
          expect(data.state, StatefulDataState.loading);
        }
        else if (listenerCallCount == 2) {
          expect(data.isLoading, false);
          expect(data.state, StatefulDataState.ready);
          expect(data.data, 'Two');
        }
        listenerCallCount++;
      });
      await Future.delayed(Duration(seconds: 1));
      data.loadData();
      await Future.delayed(Duration(seconds: 1));
    });
    // TODO: Test data loading error
  });
  group('StatefulData watcher', () {
    var listenerCallCount;
    setUp(() {
      listenerCallCount = 0;
    });
    test('Empty data', () async {
      final Stream<String?> Function() source = () => Stream<String?>
          .fromIterable(<String?>[null]);
      final data = StatefulData<String>.watch(source: source);
      expect(data.isLoading, true);
      expect(data.state, StatefulDataState.initialLoading);
      data.addListener(() {
        expect(listenerCallCount, 0);
        expect(data.isLoading, false);
        expect(data.state, StatefulDataState.empty);
        listenerCallCount++;
      });
      await Future.delayed(Duration(seconds: 1));
    });
    test('Not empty data', () async {
      final Stream<String?> Function() source = () => Stream<String?>
          .fromIterable(<String?>['One']);
      final data = StatefulData<String>.watch(source: source);
      expect(data.isLoading, true);
      expect(data.state, StatefulDataState.initialLoading);
      data.addListener(() {
        expect(listenerCallCount, 0);
        expect(data.isLoading, false);
        expect(data.state, StatefulDataState.ready);
        expect(data.data, 'One');
        listenerCallCount++;
      });
      await Future.delayed(Duration(seconds: 1));
    });
    test('Data updates', () async {
      final Stream<String?> Function() source = () => Stream<String?>
          .fromIterable(<String?>['One', 'Two']);
      final data = StatefulData<String>.watch(source: source);
      expect(data.isLoading, true);
      expect(data.state, StatefulDataState.initialLoading);
      data.addListener(() {
        if (listenerCallCount == 0) {
          expect(data.isLoading, false);
          expect(data.state, StatefulDataState.ready);
          expect(data.data, 'One');
        }
        else if (listenerCallCount == 1) {
          expect(data.isLoading, false);
          expect(data.state, StatefulDataState.ready);
          expect(data.data, 'Two');
        }
        listenerCallCount++;
      });
      await Future.delayed(Duration(seconds: 1));
    });
    // TODO: Test data loading error
  });
}
