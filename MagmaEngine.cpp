#include "MagmaEngine.hpp"
#include <iostream>
#include <string>
#include <vector>
#include <memory>
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>

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

    }



    // Set the name of the entity
    void Entity::SetName(std::string Name) {
        this->Name = Name; // Set the name of the entity
    }

    // Add a component to the entity
    void Entity::AddComponent(const std::shared_ptr<Components::Internal::BaseComponent>& Component) {
        Components.push_back(Component); // Add the component to the entity's component list
    }

    // This is used mostly internaly but for debuging a guess you could use this? 
    std::vector<std::shared_ptr<Components::Internal::BaseComponent>> Entity::GetComponentList() {
        return Components;
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
        Components::Transform* TransformComponent_ECS = nullptr;
        Components::BoxCollider* BoxColliderComponent_ECS = nullptr;
        Components::CapsuleCollider* CapsuleCollider_ECS = nullptr;
        Components::CircleCollider* CircleCollider_ECS = nullptr;
        Components::Physics* Physics_ECS = nullptr;

        // Iterate over each entity in RenderCach
        for (Entity entity : RenderCach) {

            // Iterate over each component of the current entity
            for (std::shared_ptr<Components::Internal::BaseComponent> ComponentPtr : entity.GetComponentList()) {

                // Use dynamic_cast to cast to the exact type
                if (auto TransformComponent = dynamic_cast<Components::Transform*>(ComponentPtr.get())) {
                    TransformComponent_ECS = TransformComponent;
                }
                else if (auto BoxColliderComponent = dynamic_cast<Components::BoxCollider*>(ComponentPtr.get())) {
                    BoxColliderComponent_ECS = BoxColliderComponent;
                }
                else if (auto CapsuleCollider = dynamic_cast<Components::CapsuleCollider*>(ComponentPtr.get())) {
                    CapsuleCollider_ECS = CapsuleCollider;
                }
                else if (auto CircleCollider = dynamic_cast<Components::CircleCollider*>(ComponentPtr.get())) {
                    CircleCollider_ECS = CircleCollider;
                }
                else if (auto Physics = dynamic_cast<Components::Physics*>(ComponentPtr.get())) {
                    Physics_ECS = Physics;
                }
                // To Add More Components Just add and else if statement here
            }
        }
        // This is where the actual rendering logic of the ENTIRE game engine Lives PLZ Don't touch this if you don't
        // know what you are doing


        // Load a default font
        TTF_Font* font = TTF_OpenFont(nullptr, font_size); // Passing nullptr uses the default font
        if (font == nullptr) {
            // Error handling: unable to load the default font
            // Log the error or handle it in an appropriate way
        }

        if (TransformComponent_ECS == nullptr) {
            SDL_Window* PopupWindow = SDL_CreateWindow("Error", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 400, 200, SDL_WINDOW_SHOWN);
            if (PopupWindow != nullptr) {
                SDL_Renderer* PopupRenderer = SDL_CreateRenderer(PopupWindow, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
                if (PopupRenderer != nullptr) {
                    SDL_SetRenderDrawColor(PopupRenderer, 255, 255, 255, 255); // Set background color to white
                    SDL_RenderClear(PopupRenderer);
                    // Render your message
                    SDL_Color textColor = { 0, 0, 0, 255 }; // Black color
                    SDL_Surface* textSurface = TTF_RenderText_Solid(font, "An Entity Is Missing A TransformComponent This is Required For Rendering!", textColor);
                    if (textSurface != nullptr) {
                        SDL_Texture* textTexture = SDL_CreateTextureFromSurface(PopupRenderer, textSurface);
                        if (textTexture != nullptr) {
                            SDL_Rect textRect = { 50, 50, textSurface->w, textSurface->h };
                            SDL_RenderCopy(PopupRenderer, textTexture, nullptr, &textRect);
                            SDL_RenderPresent(PopupRenderer);

                            // Wait for the user to close the popup window
                            SDL_Event event;
                            bool popupOpen = true;
                            while (popupOpen) {
                                while (SDL_PollEvent(&event)) {
                                    if (event.type == SDL_QUIT) {
                                        popupOpen = false;
                                    }
                                }
                            }
                            SDL_DestroyTexture(textTexture);
                        }
                        SDL_FreeSurface(textSurface);
                    }
                    SDL_DestroyRenderer(PopupRenderer);
                }
                SDL_DestroyWindow(PopupWindow);
            }
        }

        // Clean up the font
        TTF_CloseFont(font);


    }




}