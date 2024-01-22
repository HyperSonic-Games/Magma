#include <SDL.h>
#include <iostream>
#include <vector>
#include <algorithm>
#include "MagmaEngine.hpp"

namespace Magma {

    class Scene {
    private:
        int P_SceneX;
        int P_SceneY;
        const char* P_Title;
        SDL_Window* P_MagmaWindow;
        std::vector<const char*> P_EntityIDs;

    public:
        Scene(const char* Title, int SceneX, int SceneY) : P_Title(Title), P_SceneX(SceneX), P_SceneY(SceneY), P_MagmaWindow(nullptr) {
            if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_AUDIO) != 0) {
                std::cerr << "ERROR: <SDL> " << SDL_GetError() << std::endl;
                SDL_Quit();
            }

            P_MagmaWindow = SDL_CreateWindow(Title, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SceneX, SceneY, SDL_WINDOW_SHOWN);
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

        const char* M_GetTitle() const {
            return P_Title;
        }

        int M_GetX() const {
            return P_SceneX;
        }

        int M_GetY() const {
            return P_SceneY;
        }

        SDL_Window* M_GetMagmaWindow() {
            return P_MagmaWindow;
        }

        std::vector<const char*> M_GetEntityIDs() const {
            return P_EntityIDs;
        }

        void M_AddID(const char* EntityID) {
            P_EntityIDs.push_back(EntityID);
        }
        void M_RemoveID(const char* EntityID) {
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
        std::vector<const char*> Components;

    public:
        Entity(const char* EntityID, int EntityX, int EntityY, Scene& scene) : P_EntityID(EntityID), P_EntityX(EntityX), P_EntityY(EntityY) {
            if (std::find(scene.M_GetEntityIDs().begin(), scene.M_GetEntityIDs().end(), EntityID) != scene.M_GetEntityIDs().end()) {
                std::cout << "ERROR: <MagmaEngine> New Entity Initialized With An Existing EntityID" << std::endl;
                SDL_Quit();
            }
            else if (EntityX > scene.M_GetX()) {
                std::cout << "ERROR: <MagmaEngine> New Entity Initialized With An X Value Bigger Than The Screen's Current X Value" << std::endl;
                SDL_Quit();
            }
            else if (EntityY > scene.M_GetY()) {
                std::cout << "ERROR: <MagmaEngine> New Entity Initialized With A Y Value Bigger Than The Screen's Current Y Value" << std::endl;
                SDL_Quit();
            }
            else {
                scene.M_AddID(EntityID); // Add the new entity ID to the scene
                P_EntityX = EntityX;
                P_EntityY = EntityY;
                P_EntityID = EntityID;
                // Add further initialization logic if needed
            }
        }
    };

}  // namespace Magma
