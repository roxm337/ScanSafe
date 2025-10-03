<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdatePreferencesRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'allergies' => 'nullable|array',
            'allergies.*' => 'string|max:255',
            'dietary_restrictions' => 'nullable|array',
            'dietary_restrictions.*' => 'string|max:255',
            'lifestyle_preferences' => 'nullable|array',
            'lifestyle_preferences.*' => 'string|max:255',
            'ingredient_alerts' => 'nullable|array',
            'ingredient_alerts.*' => 'string|max:255',
            'notifications_enabled' => 'nullable|boolean',
            'profile_image' => 'nullable|string|max:255',
        ];
    }
}
