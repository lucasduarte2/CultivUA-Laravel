<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AdminAuthController extends Controller
{


    // Login via API (com Sanctum)
    public function login(Request $request)
    {
        $request->validate([
            'username' => 'required|string',
            'password' => 'required|string',
        ]);

        $credentials = $request->only('username', 'password');

        if (Auth::guard('admin')->attempt($credentials)) {
            $admin = Auth::guard('admin')->user();
            $token = $admin->createToken('AdminToken', ['admin'])->plainTextToken;

            return response()->json([
                'id' => $admin->id,
                'token' => $token,
                'email' => $admin->email,
                'image' => $admin->image,
                'username' => $admin->username,
                'user_type' => 'admin',
                'role' => 'admin', // Adiciona explicitamente a role para verificar no frontend
            ]);
        }

        return response()->json(['error' => 'Unauthorized'], 401);
    }


    // Logout via API
    public function logout(Request $request)
    {
        $user = Auth::guard('admin_api')->user(); // Recupera o usuário autenticado

        if ($user) {
            // Deleta todos os tokens associados ao admin
            $user->tokens->each(function ($token) {
                $token->delete();
            });

            return response()->json(['message' => 'Logout realizado com sucesso'], 200);
        }

        // Se o usuário não estiver autenticado
        return response()->json(['error' => 'Não autenticado'], 401);
    }
}
