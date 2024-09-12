#pragma once
#include <iostream>
#include "../../apis/geo/shape.h"

// Derived classes
class Rectangle : public Shape
{

private:
    int width;
    int height;

public:
    Rectangle(int width, int height)
    {
        this->height = height;
        this->width = width;
    }

    ~Rectangle()
    {
        std::cout << "Rectangle is being deleted" << std::endl;
    }

    float getArea()
    {
        return (this->width * this->height);
    }
};