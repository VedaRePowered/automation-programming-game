#include <iostream>
#include <raylib.h>

int main(void) {
	InitWindow(800, 600, "Automation Game");
	while (!WindowShouldClose()) {
		BeginDrawing();
		ClearBackground(BLACK);
		DrawText("I'm gonna clone your repo ;)", 100, 100, 20, RED);
		EndDrawing();
	}
	CloseWindow();
	return 0;
}
