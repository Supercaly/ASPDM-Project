import 'package:aspdm_project/domain/values/task_values.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/domain/entities/task.dart';
import 'package:aspdm_project/domain/repositories/task_repository.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Class used to manage the state of the task info page.
class TaskBloc extends Cubit<TaskState> {
  final TaskRepository _repository;
  final LogService _logService;

  /// Id of the task that we want to display.
  final UniqueId _taskId;

  /// Keep in memory the old data so it
  /// can be displayed even during loading
  /// or errors.
  Task _oldTask;

  TaskBloc(
    this._taskId,
    this._repository,
  )   : _logService = locator<LogService>(),
        super(TaskState.loading(null));

  /// Tells [TaskRepository] to fetch the task with id [_taskId].
  Future<void> fetch({bool showLoading = true}) async {
    if (showLoading) emit(TaskState.loading(_oldTask));

    (await _repository.getTask(_taskId)).fold(
      (_) => emit(TaskState.error(_oldTask)),
      (newTask) {
        _oldTask = newTask;
        emit(TaskState.data(newTask));
      },
    );
  }

  /// Tells [TaskRepository] the user wants to delete one of his
  /// comments under this task.
  Future<void> deleteComment(UniqueId commentId, UniqueId userId) async {
    (await _repository.deleteComment(_oldTask?.id, commentId, userId)).fold(
      (e) {
        _logService.error("TaskBloc.deleteComment: ", e);
        emit(TaskState.error(_oldTask));
      },
      (newTask) {
        _oldTask = newTask;
        emit(TaskState.data(newTask));
      },
    );
  }

  /// Tells [TaskRepository] the user wants to edit one of his
  /// comments under this task.
  Future<void> editComment(
    UniqueId commentId,
    CommentContent newContent,
    UniqueId userId,
  ) async {
    (await _repository.editComment(_oldTask?.id, commentId, newContent, userId))
        .fold(
      (e) {
        _logService.error("TaskBloc.editComment: ", e);
        emit(TaskState.error(_oldTask));
      },
      (newTask) {
        _oldTask = newTask;
        emit(TaskState.data(newTask));
      },
    );
  }

  /// Tells [TaskRepository] the user created a new comment under this task.
  Future<void> addComment(CommentContent content, UniqueId userId) async {
    (await _repository.addComment(_oldTask?.id, content, userId)).fold(
      (e) {
        _logService.error("TaskBloc.addComment: ", e);
        emit(TaskState.error(_oldTask));
      },
      (newTask) {
        _oldTask = newTask;
        emit(TaskState.data(newTask));
      },
    );
  }

  /// Tells [TaskRepository] the user likes a comment under this task.
  Future<void> likeComment(UniqueId commentId, UniqueId userId) async {
    (await _repository.likeComment(_oldTask?.id, commentId, userId)).fold(
      (e) {
        _logService.error("TaskBloc.likeComment: ", e);
        emit(TaskState.error(_oldTask));
      },
      (newTask) {
        _oldTask = newTask;
        emit(TaskState.data(newTask));
      },
    );
  }

  /// Tells [TaskRepository] the user dislikes a comment under this task.
  Future<void> dislikeComment(UniqueId commentId, UniqueId userId) async {
    (await _repository.dislikeComment(_oldTask?.id, commentId, userId)).fold(
      (e) {
        _logService.error("TaskBloc.dislikeComment: ", e);
        emit(TaskState.error(_oldTask));
      },
      (newTask) {
        _oldTask = newTask;
        emit(TaskState.data(newTask));
      },
    );
  }

  /// Tells [TaskRepository] the task is archived.
  Future<void> archive(UniqueId userId) async {
    (await _repository.archiveTask(_oldTask?.id, userId)).fold(
      (e) {
        _logService.error("TaskBloc.archive: ", e);
        emit(TaskState.error(_oldTask));
      },
      (newTask) {
        _oldTask = newTask;
        emit(TaskState.data(newTask));
      },
    );
  }

  /// Tells [TaskRepository] the task is un-archived.
  Future<void> unarchive(UniqueId userId) async {
    (await _repository.unarchiveTask(_oldTask?.id, userId)).fold(
      (e) {
        _logService.error("TaskBloc.unarchive: ", e);
        emit(TaskState.error(_oldTask));
      },
      (newTask) {
        _oldTask = newTask;
        emit(TaskState.data(newTask));
      },
    );
  }

  /// Tells [TaskRepository] a checklist's item is completed.
  Future<void> completeChecklist(
    UniqueId userId,
    UniqueId checklistId,
    UniqueId itemId,
    Toggle complete,
  ) async {
    (await _repository.completeChecklist(
      _oldTask?.id,
      userId,
      checklistId,
      itemId,
      complete,
    ))
        .fold(
      (e) {
        _logService.error("TaskBlock.completeChecklist: ", e);
        emit(TaskState.error(_oldTask));
      },
      (newTask) {
        _oldTask = newTask;
        emit(TaskState.data(newTask));
      },
    );
  }
}

/// Class with the state of the [TaskBloc].
class TaskState extends Equatable {
  /// Tells the widget that the data is loading.
  final bool isLoading;

  /// Tells the widget that there was an error.
  final bool hasError;

  /// The task to display.
  final Task data;

  /// Constructor for the data.
  const TaskState.data(this.data)
      : isLoading = false,
        hasError = false;

  /// Constructor for loading.
  const TaskState.loading(this.data)
      : isLoading = true,
        hasError = false;

  /// Constructor for error.
  const TaskState.error(this.data)
      : isLoading = false,
        hasError = true;

  @override
  String toString() =>
      "TaskState {isLoading: $isLoading, hasError: $hasError, data: $data}";

  @override
  List<Object> get props => [isLoading, hasError, data];
}