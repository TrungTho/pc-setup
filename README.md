### Preface

This is repository is used to keep all the necessary dependencies for my PC. It mostly utilize the power of ansible for Configuration as Code (except for windows machine in which a powershell script may be the most straightforward way)

### Folder Structure Explanation

- **`src/`**: Contains all source code for the application.
  - **`components/`**: Reusable UI components like buttons, cards, etc.
  - **`pages/`**: Top-level components representing different views or pages of the application.
  - **`App.js`**: The main application component.
- **`public/`**: Static assets served directly by the web server.
  - **`index.html`**: The main HTML file.
  - **`assets/`**: Contains images, stylesheets, and other static resources.
- **`tests/`**: Contains all unit and integration tests for the project.
- **`.env`**: Environment variables for configuration.
- **`package.json`**: Project metadata and dependencies (for Node.js projects).
