<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\UpdatePreferencesRequest;

class PreferenceController extends Controller
{
    /**
     * Display the user's preferences.
     */
    public function show()
    {
        return response()->json(auth()->user()->preference);
    }

    /**
     * Update the user's preferences.
     */
    public function update(UpdatePreferencesRequest $request)
    {
        auth()->user()->preference->update($request->validated());

        return response()->json(auth()->user()->preference);
    }
}
