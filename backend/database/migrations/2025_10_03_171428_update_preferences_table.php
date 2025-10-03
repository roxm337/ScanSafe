<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('preferences', function (Blueprint $table) {
            // Remove old boolean columns
            $table->dropColumn([
                'vegan', 
                'diabetic', 
                'gluten_free', 
                'nut_allergy', 
                'lactose_intolerant'
            ]);
            
            // Add new flexible columns
            $table->json('allergies')->default(json_encode([]));
            $table->json('dietary_restrictions')->default(json_encode([]));
            $table->json('lifestyle_preferences')->default(json_encode([]));
            $table->json('ingredient_alerts')->default(json_encode([]));
            $table->boolean('notifications_enabled')->default(true);
            $table->string('profile_image')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('preferences', function (Blueprint $table) {
            // Add back the old columns
            $table->boolean('vegan')->default(false);
            $table->boolean('diabetic')->default(false);
            $table->boolean('gluten_free')->default(false);
            $table->boolean('nut_allergy')->default(false);
            $table->boolean('lactose_intolerant')->default(false);
            
            // Remove new columns
            $table->dropColumn([
                'allergies',
                'dietary_restrictions',
                'lifestyle_preferences',
                'ingredient_alerts',
                'notifications_enabled',
                'profile_image'
            ]);
        });
    }
};
