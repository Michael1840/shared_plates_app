import 'package:shared_plates_app/core/domain/feed.dart';
import 'package:shared_plates_app/core/utils/delayed_result.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';

typedef FeedSlice<T> = DelayedResult<Feed<T>>;

extension FeedSliceX<T> on FeedSlice<T> {
  bool get isStale => value?.isStale ?? false;

  FeedSlice<T> loadingFrom() =>
      isSuccessful ? this : const DelayedResult.inProgress();
}

FeedSlice<T> sliceFrom<T>(Result<Feed<T>> result, FeedSlice<T> previous) =>
    switch (result) {
      Ok(:final value) => DelayedResult.fromValue(value),
      Error(:final error) =>
        previous.isSuccessful
            ? previous
            : DelayedResult.fromError(error.cleanError),
      CastError() =>
        previous.isSuccessful
            ? previous
            : const DelayedResult.fromError(BrowseMessages.generic),
    };
