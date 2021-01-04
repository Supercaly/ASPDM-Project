import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/presentation/bloc/task_bloc.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_log_service.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  group("TaskBloc Tests", () {
    TaskRepository repository;

    setUp(() {
      repository = MockTaskRepository();
    });

    setUpAll(() {
      GetIt.I.registerLazySingleton<LogService>(() => MockLogService());
    });

    blocTest(
      "emits nothing when created",
      build: () => TaskBloc("mock_id", repository),
      expect: [],
    );

    blocTest("emits data on fetch success",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.getTask(any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
                  "mock_id",
                  "mock title",
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                ),
              ),
            ),
          );
          bloc.fetch();
        },
        expect: [
          TaskState.loading(null),
          TaskState.data(Task(
            "mock_id",
            "mock title",
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          )),
        ]);

    blocTest(
      "emits error on fetch error",
      build: () => TaskBloc("mock_id", repository),
      act: (TaskBloc bloc) {
        when(repository.getTask(any))
            .thenAnswer((_) => Future.value(Either.left(ServerFailure())));
        bloc.fetch();
      },
      expect: [
        TaskState.loading(null),
        TaskState.error(null),
      ],
    );

    blocTest(
      "don't emits loading when fetch has showLoading false",
      build: () => TaskBloc("mock_id", repository),
      act: (TaskBloc bloc) {
        when(repository.getTask(any)).thenAnswer(
          (_) => Future.value(
            Either.right(
              Task(
                "mock_id",
                "mock title",
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
              ),
            ),
          ),
        );
        bloc.fetch(showLoading: false);
      },
      expect: [
        TaskState.data(Task(
          "mock_id",
          "mock title",
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        )),
      ],
    );

    blocTest("emits data on comment delete success",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.deleteComment(any, any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
                  "mock_id",
                  "mock title",
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                ),
              ),
            ),
          );
          bloc.deleteComment("commentId", "userId");
        },
        expect: [
          TaskState.data(Task(
            "mock_id",
            "mock title",
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          )),
        ]);

    blocTest("emits error on comment delete error",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.deleteComment(any, any, any))
              .thenAnswer((_) => Future.value(Either.left(ServerFailure())));
          bloc.deleteComment("commentId", "userId");
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on comment edit success",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.editComment(any, any, any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
                  "mock_id",
                  "mock title",
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                ),
              ),
            ),
          );
          bloc.editComment("commentId", "newContent", "userId");
        },
        expect: [
          TaskState.data(Task(
            "mock_id",
            "mock title",
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          )),
        ]);

    blocTest("emits error on comment edit error",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.editComment(any, any, any, any))
              .thenAnswer((_) => Future.value(Either.left(ServerFailure())));
          bloc.editComment("commentId", "newContent", "userId");
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on comment like success",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.likeComment(any, any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
                  "mock_id",
                  "mock title",
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                ),
              ),
            ),
          );
          bloc.likeComment("commentId", "userId");
        },
        expect: [
          TaskState.data(Task(
            "mock_id",
            "mock title",
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          )),
        ]);

    blocTest("emits error on comment like error",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.likeComment(any, any, any))
              .thenAnswer((_) => Future.value(Either.left(ServerFailure())));
          bloc.likeComment("commentId", "userId");
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on comment dislike success",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.dislikeComment(any, any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
                  "mock_id",
                  "mock title",
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                ),
              ),
            ),
          );
          bloc.dislikeComment("commentId", "userId");
        },
        expect: [
          TaskState.data(Task(
            "mock_id",
            "mock title",
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          )),
        ]);

    blocTest("emits error on comment dislike error",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.dislikeComment(any, any, any))
              .thenAnswer((_) => Future.value(Either.left(ServerFailure())));
          bloc.dislikeComment("commentId", "userId");
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on add comment success",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.addComment(any, any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
                  "mock_id",
                  "mock title",
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                ),
              ),
            ),
          );
          bloc.addComment("content", "userId");
        },
        expect: [
          TaskState.data(Task(
            "mock_id",
            "mock title",
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          )),
        ]);

    blocTest("emits error on add comment error",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.addComment(any, any, any))
              .thenAnswer((_) => Future.value(Either.left(ServerFailure())));
          bloc.addComment("content", "userId");
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on archive success",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.archiveTask(any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
                  "mock_id",
                  "mock title",
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                ),
              ),
            ),
          );
          bloc.archive("userId");
        },
        expect: [
          TaskState.data(Task(
            "mock_id",
            "mock title",
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          )),
        ]);

    blocTest("emits error on archive error",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.archiveTask(any, any))
              .thenAnswer((_) => Future.value(Either.left(ServerFailure())));
          bloc.archive("userId");
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on unarchive success",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.unarchiveTask(any, any)).thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
                  "mock_id",
                  "mock title",
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                ),
              ),
            ),
          );
          bloc.unarchive("userId");
        },
        expect: [
          TaskState.data(Task(
            "mock_id",
            "mock title",
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          )),
        ]);

    blocTest("emits error on unarchive error",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.unarchiveTask(any, any))
              .thenAnswer((_) => Future.value(Either.left(ServerFailure())));
          bloc.unarchive("userId");
        },
        expect: [
          TaskState.error(null),
        ]);

    blocTest("emits data on complete checklist success",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.completeChecklist(any, any, any, any, any))
              .thenAnswer(
            (_) => Future.value(
              Either.right(
                Task(
                  "mock_id",
                  "mock title",
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                ),
              ),
            ),
          );
          bloc.completeChecklist("userId", "checklistId", "itemId", true);
        },
        expect: [
          TaskState.data(Task(
            "mock_id",
            "mock title",
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          )),
        ]);

    blocTest("emits error on complete checklist error",
        build: () => TaskBloc("mock_id", repository),
        act: (TaskBloc bloc) {
          when(repository.completeChecklist(any, any, any, any, any))
              .thenAnswer((_) => Future.value(Either.left(ServerFailure())));
          bloc.completeChecklist("userId", "checklistId", "itemId", true);
        },
        expect: [
          TaskState.error(null),
        ]);
  });
}