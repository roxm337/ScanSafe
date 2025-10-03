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
            'vegan' => 'nullable|boolean',
            'diabetic' => 'nullable|boolean',
            'gluten_free' => 'nullable|boolean',
            'nut_allergy' => 'nullable|boolean',
            'lactose_intolerant' => 'nullable|boolean',
        ];
    }
}
