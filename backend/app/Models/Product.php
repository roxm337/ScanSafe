<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = ['ean', 'name', 'brand', 'image_url', 'ingredients_text', 'allergens', 'source_api', 'cached_at'];

    protected $casts = [
        'allergens' => 'array',
    ];

    public function scans()
    {
        return $this->hasMany(Scan::class);
    }
}
