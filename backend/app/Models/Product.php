<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;

class Product extends Model
{
    use HasFactory;
    
    protected $fillable = ['ean', 'name', 'brand', 'image_url', 'ingredients_text', 'allergens', 'source_api', 'cached_at'];

    protected $casts = [
        'allergens' => 'array',
    ];

    public function scans(): HasMany
    {
        return $this->hasMany(Scan::class);
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(ProductReview::class);
    }

    public function recommendations(): HasMany
    {
        return $this->hasMany(Recommendation::class, 'product_id');
    }

    public function recommendedProducts(): HasMany
    {
        return $this->hasMany(Recommendation::class, 'recommended_product_id');
    }
}
