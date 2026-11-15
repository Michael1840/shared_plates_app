import 'package:mocktail/mocktail.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_actions_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockSyncService extends Mock implements SyncService {}

class MockSettingsStore extends Mock implements AppSettingsStore {}

class MockAppDatabase extends Mock implements AppDatabase {}

class MockBrowseRepository extends Mock implements BrowseRepository {}

class MockRecipeActionsRepository extends Mock
    implements RecipeActionsRepository {}
