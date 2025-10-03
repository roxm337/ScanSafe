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
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('ean')->unique()->index();
            $table->string('name')->nullable();
            $table->string('brand')->nullable();
            $table->string('image_url')->nullable();
            $table->text('ingredients_text')->nullable();
            $table->json('allergens')->nullable();
            $table->string('source_api')->nullable();
            $table->timestamp('cached_at')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
