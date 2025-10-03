<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Preference extends Model
{
    protected $fillable = ['user_id', 'vegan', 'diabetic', 'gluten_free', 'nut_allergy', 'lactose_intolerant'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
