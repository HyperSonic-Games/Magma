#include "MagmaEngine.hpp"
#include <iostream>
#include <string>
#include <vector>
#include <memory>
#include <SDL.h>
#include <SDL_image.h>

namespace Magma {
    // Initialize the Magma Game Engine
    void Init() {
        if (SDL_Init(SDL_INIT_EVERYTHING) != 0) {
            std::cerr << SDL_GetError(); // Output error message if SDL initialization fails
            exit(1); // Exit the program with error code 1
        }
    }

    namespace Types {
        // Constructor for 2D vector
        Vec2::Vec2(unsigned int X, unsigned int Y) {
            this->X = X; // Initialize X coordinate
            this->Y = Y; // Initialize Y coordinate
        }

        // Getter for X coordinate
        unsigned int Vec2::GetX() const {
            return this->X; // Return X coordinate
        }

        // Getter for Y coordinate
        unsigned int Vec2::GetY() const {
            return this->Y; // Return Y coordinate
        }

        // Setter for X coordinate
        void Vec2::SetX(unsigned int X) {
            this->X = X; // Set X coordinate
        }

        // Setter for Y coordinate
        void Vec2::SetY(unsigned int Y) {
            this->Y = Y; // Set Y coordinate
        }

        // Constructor for RGBA color
        RgbaColor::RgbaColor(unsigned int Red, unsigned int Green, unsigned int Blue, unsigned int Alpha) {
            if (Red > 255 or Green > 255 or Blue > 255 or Alpha > 255) {
                std::cerr << "An rgba color value can not be higher than 255"; // Output error message if color values are out of range
                exit(1); // Exit the program with error code 1
            }
            else {
                Color.r = Red; // Initialize red component
                Color.g = Green; // Initialize green component
                Color.b = Blue; // Initialize blue component
                Color.a = Alpha; // Initialize alpha component
            }
        }

        // Getter for red component
        unsigned int RgbaColor::GetRed() const {
            return this->Color.r; // Return red component
        }

        // Getter for green component
        unsigned int RgbaColor::GetGreen() const {
            return this->Color.g; // Return green component
        }

        // Getter for blue component
        unsigned int RgbaColor::GetBlue() const {
            return this->Color.b; // Return blue component
        }

        // Getter for alpha component
        unsigned int RgbaColor::GetAlpha() const {
            return this->Color.a; // Return alpha component
        }

        // Setter for red component
        void RgbaColor::SetRed(unsigned int Red) {
            if (Red > 255) {
                std::cerr << "An rgba color value can not be higher than 255"; // Output error message if color value is out of range
                exit(1); // Exit the program with error code 1
            }
            else {
                this->Color.r = Red; // Set red component
            }
        }

        // Setter for green component
        void RgbaColor::SetGreen(unsigned int Green) {
            if (Green > 255) {
                std::cerr << "An rgba color value can not be higher than 255"; // Output error message if color value is out of range
                exit(1); // Exit the program with error code 1
            }
            else {
                this->Color.g = Green; // Set green component
            }
        }

        // Setter for blue component
        void RgbaColor::SetBlue(unsigned int Blue) {
            if (Blue > 255) {
                std::cerr << "An rgba color value can not be higher than 255"; // Output error message if color value is out of range
                exit(1); // Exit the program with error code 1
            }
            else {
                this->Color.b = Blue; // Set blue component
            }
        }

        // Setter for alpha component
        void RgbaColor::SetAlpha(unsigned int Alpha) {
            if (Alpha > 255) {
                std::cerr << "An rgba color value can not be higher than 255"; // Output error message if color value is out of range
                exit(1); // Exit the program with error code 1
            }
            else {
                this->Color.a = Alpha; // Set alpha component
            }
        }
    }

    namespace Components {
        // Move the entity to a new position
        void Transform::MoveTo(const Types::Vec2& Position) {
            this->Position = Position; // Set position to the provided value
        }

        // Move the entity by a certain offset
        void Transform::MoveBy(const Types::Vec2& Offset) {
            this->Position.SetX(this->Position.GetX() + Offset.GetX()); // Add offset to current X coordinate
            this->Position.SetY(this->Position.GetY() + Offset.GetY()); // Add offset to current Y coordinate
        }

        // Set the rotation of the entity
        void Transform::SetRotation(float Rotation) {
            this->Rotation = Rotation; // Set rotation to the provided value
        }

        // Set the scale of the entity
        void Transform::SetScale(float Scale) {
            this->Scale = Scale; // Set scale to the provided value
        }

        // Getter for position of the entity
        Types::Vec2 Transform::GetPosition() const {
            return this->Position; // Return the position vector
        }

        // Getter for rotation of the entity
        float Transform::GetRotation() {
            return this->Rotation; // Return the rotation value
        }

        // Getter for scale of the entity
        float Transform::GetScale() {
            return this->Scale; // Return the scale value
        }


    }



    // Set the name of the entity
    void Entity::SetName(std::string Name) {
        this->Name = Name; // Set the name of the entity
    }

    // Add a component to the entity
    void Entity::AddComponent(const std::shared_ptr<Components::BaseComponent>& Component) {
        Components.push_back(Component); // Add the component to the entity's component list
    }

    Renderer::Renderer(const char* Title, Types::Vec2 WindowCreationOrgin, unsigned int WindowWidth, unsigned int WindowHeight, bool Fullscreen) {
        if (Fullscreen) {
            this->WindowContext = SDL_CreateWindow(Title, WindowCreationOrgin.GetX(), WindowCreationOrgin.GetY(), WindowWidth, WindowHeight, SDL_WINDOW_FULLSCREEN);
            if (!this->WindowContext) {
                std::cerr << "Failed to create fullscreen window: " << SDL_GetError();
                exit(1);
            }
            this->RendererContext = SDL_CreateRenderer(WindowContext, -1, SDL_RENDERER_ACCELERATED);
            if (!this->RendererContext) {
                std::cerr << "Failed to create renderer: " << SDL_GetError();
                exit(1);
            }
        }
        else {
            WindowContext = SDL_CreateWindow(Title, WindowCreationOrgin.GetX(), WindowCreationOrgin.GetY(), WindowWidth, WindowHeight, 0);
            if (!WindowContext) {
                std::cerr << "Failed to create windowed mode window: " << SDL_GetError();
                exit(1);
            }
            RendererContext = SDL_CreateRenderer(WindowContext, -1, SDL_RENDERER_ACCELERATED);
            if (!RendererContext) {
                std::cerr << "Failed to create renderer: " << SDL_GetError();
                exit(1);
            }
        }
    }

    Renderer::~Renderer() {
        SDL_DestroyRenderer(this->RendererContext);
        SDL_DestroyWindow(this->WindowContext);
    }

    void Renderer::AddToRendererCache(Entity Entity) {
        this->RenderCach.push_back(Entity);
    }

    void Renderer::Clear(Types::RgbaColor ClearColor) {
        // Set the RGBA color (e.g., red with alpha 128)
        if (!SDL_SetRenderDrawColor(RendererContext, ClearColor.GetRed(), ClearColor.GetGreen(), ClearColor.GetBlue(), ClearColor.GetAlpha())) {
            std::cerr << SDL_GetError();
            exit(1);
        }

        // Clear the screen with the RGBA color
        if (!SDL_RenderClear(RendererContext)) {
            std::cerr << SDL_GetError();
            exit(1);
        }

        if (!SDL_SetRenderDrawColor(RendererContext, 0, 0, 0, 255)) {
            std::cerr << SDL_GetError();
            exit(1);
        }
        
        // Present the renderer
        SDL_RenderPresent(RendererContext);
    }

    void Renderer::Update() {
        // Jesus crist why are ECS so dam difficult
       // TODO: Emplement pain and suffering
    }
 

}