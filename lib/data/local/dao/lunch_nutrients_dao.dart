import 'package:floor/floor.dart';
import 'package:calorie_counter/data/local/entity/lunch_nutrients.dart';

@dao
abstract class LunchNutrientsDao {

  @Query('SELECT * FROM lunch_nutrients WHERE id = :id')
  Future<LunchNutrients> findLunchById(int id);

  @Insert(onConflict: OnConflictStrategy.IGNORE)
  Future<int> insertLunch(LunchNutrients lunchNutrients);

  @Update(onConflict: OnConflictStrategy.IGNORE)
  Future<int> updateLunch(LunchNutrients lunchNutrients);

  @delete
  Future<int> deleteLunch(LunchNutrients lunchNutrients);

  void upsert(LunchNutrients lunchNutrients) async {
    final id = await insertLunch(lunchNutrients);
  
    if (id == -1) {
      await updateLunch(lunchNutrients);
    }
  }

}