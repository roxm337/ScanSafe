<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductReview extends Model
{
    use HasFactory;
    
    protected $fillable = [
        'user_id',
        'product_id',
        'review_text',
        'rating',
        'tags',
        'is_verified',
        'helpful_votes'
    ];

    protected $casts = [
        'tags' => 'array',
        'helpful_votes' => 'array',
        'is_verified' => 'boolean',
        'rating' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}