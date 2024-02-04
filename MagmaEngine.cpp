#include <SDL.h>
#include <iostream>
#include <vector>
#include <algorithm>
#include "MagmaEngine.hpp"



namespace Magma {

    class Scene {
    private:
        unsigned int P_SceneX;
        unsigned int P_SceneY;
        const char* P_Title;
        SDL_Window* P_MagmaWindow;
        std::vector<const char*> P_EntityIDs;
        unsigned int P_FpsTarget;

    public:
        Scene(const char* Title, unsigned int SceneX, unsigned int SceneY, unsigned int FpsTarget = 60)
        : P_Title(Title), P_SceneX(SceneX), P_SceneY(SceneY), P_MagmaWindow(nullptr), P_FpsTarget(FpsTarget) {


            if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_AUDIO) != 0) {
                std::cerr << "ERROR: <SDL> ~ " << SDL_GetError() << std::endl;
                SDL_Quit();
            }

            P_MagmaWindow = SDL_CreateWindow(P_Title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, P_SceneX, P_SceneY, SDL_WINDOW_SHOWN);
            if (P_MagmaWindow == nullptr) {
                std::cerr << "Error: <SDL> " << SDL_GetError() << std::endl;
                SDL_Quit();
            }
            
        }

        ~Scene() {
            if (P_MagmaWindow != nullptr) {
                SDL_DestroyWindow(P_MagmaWindow);
            }
            SDL_Quit();
        }

        const char* GetTitle() const {
            return P_Title;
        }

        int GetX() const {
            return P_SceneX;
        }

        int GetY() const {
            return P_SceneY;
        }

        SDL_Window* GetMagmaWindow() {
            return P_MagmaWindow;
        }

        std::vector<const char*> GetEntityIDs() const {
            return P_EntityIDs;
        }

        void AddID(const char* EntityID) {
            P_EntityIDs.push_back(EntityID);
        }
        void RemoveID(const char* EntityID) {
            auto it = std::find(P_EntityIDs.begin(), P_EntityIDs.end(), EntityID);

            if (it != P_EntityIDs.end()) {
                P_EntityIDs.erase(it);
            }
        }

    };

    class Entity {
    private:
        const char* P_EntityID;
        int P_EntityX;
        int P_EntityY;
        Scene& P_Scene;

    public:
        Entity(const char* EntityID, int EntityX, int EntityY, Scene& Scene) : P_EntityID(EntityID), P_EntityX(EntityX), P_EntityY(EntityY), P_Scene(Scene) {
            if (std::find(P_Scene.GetEntityIDs().begin(), P_Scene.GetEntityIDs().end(), EntityID) != P_Scene.GetEntityIDs().end()) {
                std::cout << "ERROR: <MagmaEngine> New Entity Initialized With An Existing EntityID" << std::endl;
                SDL_Quit();
            }
            else if (EntityX > P_Scene.GetX()) {
                std::cout << "ERROR: <MagmaEngine> New Entity Initialized With An X Value Bigger Than The Screen's Current X Value" << std::endl;
                SDL_Quit();
            }
            else if (EntityY > P_Scene.GetY()) {
                std::cout << "ERROR: <MagmaEngine> New Entity Initialized With A Y Value Bigger Than The Screen's Current Y Value" << std::endl;
                SDL_Quit();
            }
            else {
                P_Scene.AddID(P_EntityID);
            }
        }
        ~Entity(){
            P_Scene.RemoveID(P_EntityID);

        }
    };


    class Renderer {
    private:
        SDL_Renderer* P_SDLRenderer;

    public:
        Renderer(SDL_Window* window) : P_SDLRenderer(nullptr) {
            // Create SDL_Renderer
            P_SDLRenderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);

            if (P_SDLRenderer == nullptr) {
                std::cerr << "Error: <SDL> Failed to create renderer: " << SDL_GetError() << std::endl;
                SDL_Quit();
            }
        }

        ~Renderer() {
            if (P_SDLRenderer != nullptr) {
                SDL_DestroyRenderer(P_SDLRenderer);
            }
        }

        void Clear() const {
            SDL_RenderClear(P_SDLRenderer);
        }

        void Render() const {
            SDL_RenderPresent(P_SDLRenderer);
        }

        // Example rendering method (draw a filled rectangle)
        void DrawRect(int x, int y, int width, int height) const {
            SDL_Rect rect = { x, y, width, height };
            SDL_SetRenderDrawColor(P_SDLRenderer, 255, 255, 255, 255); // White color
            SDL_RenderFillRect(P_SDLRenderer, &rect);
        }

        // Add more rendering methods as needed (images, textures, etc.)
    };



}  // namespace Magma
