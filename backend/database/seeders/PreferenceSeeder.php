<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Preference;
use App\Models\User;

class PreferenceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create preferences for existing users
        $users = User::all();
        
        foreach ($users as $user) {
            if (!$user->preference) {
                Preference::create([
                    'user_id' => $user->id,
                    'allergies' => $user->id % 3 == 0 ? ['Nuts', 'Gluten'] : ($user->id % 2 == 0 ? ['Lactose'] : []),
                    'dietary_restrictions' => $user->id % 3 == 0 ? ['Vegan', 'Organic'] : ($user->id % 2 == 0 ? ['Vegetarian'] : []),
                    'lifestyle_preferences' => ['Eco-friendly', 'Cruelty-free'],
                    'ingredient_alerts' => [],
                    'notifications_enabled' => true,
                ]);
            }
        }
        
        // Create specific preferences for testing
        if (User::find(1)) {
            Preference::updateOrCreate(
                ['user_id' => 1],
                [
                    'allergies' => ['Nuts', 'Peanuts'],
                    'dietary_restrictions' => ['Vegan', 'Organic'],
                    'lifestyle_preferences' => ['Eco-friendly', 'Cruelty-free'],
                    'ingredient_alerts' => [],
                    'notifications_enabled' => true,
                ]
            );
        }
    }
}
