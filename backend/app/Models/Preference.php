<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Preference extends Model
{
    protected $fillable = [
        'user_id', 
        'allergies', 
        'dietary_restrictions', 
        'lifestyle_preferences', 
        'ingredient_alerts', 
        'notifications_enabled',
        'profile_image'
    ];

    protected $casts = [
        'allergies' => 'array',
        'dietary_restrictions' => 'array',
        'lifestyle_preferences' => 'array',
        'ingredient_alerts' => 'array',
        'notifications_enabled' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
