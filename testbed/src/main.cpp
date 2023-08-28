#include <iostream>

#include <math/Vector2.hpp>

int main()
{
	stw::Vector2 vec{1.0f, 2.0f};
	vec = vec.Normalized();
	std::cout << "Hello borld\n" << vec.x << " " << vec.y << "\n";
}