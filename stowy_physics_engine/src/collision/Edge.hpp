#pragma once

#include "math/Vector2.hpp"
#include "defines.hpp"

namespace stw
{
struct STWAPI Edge
{
    Vector2 max;
    Vector2 p1;
    Vector2 p2;

    [[nodiscard]] float VecDot(const Vector2& v) const;
    [[nodiscard]] Vector2 EdgeVector() const;
};
}
