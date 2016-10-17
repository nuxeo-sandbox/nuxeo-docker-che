# Nuxeo's Codenvy Development Environment

Welcome to the Nuxeo Codenvy development environment, it will help you navigating through the Nuxeo Source Code and deploy your code. It contains the whole sources based on the `master` branch, and the corresponding Nuxeo Platform ready to run.

# Commands Descriptions:

- **Test Project**: Run a Maven `test` command on the current project
- **Build Project**: Run a Maven `install` command on the current project
- **Deploy Project**: Run a Maven `install` command on the current project, copy output jars. Server must be restarted after that.
- **Run Nuxeo**: Start the Nuxeo Platform, then follow the logs on the current tab
- **Restart Nuxeo**: Restart the Nuxeo Platform

# Sub-Modules Organization

The project is splitted in several sub-modules (listed in dependency order):

- **nuxeo-common**: Common utilities
- **nuxeo-runtime**: Container and runtime basic services
- **nuxeo-core**: Document/content management core services
- **nuxeo-services**: Basic services such as file manager, directories, document types
- **nuxeo-theme**: Services related to the theme and theme rendering
- **nuxeo-jsf**: JSF related services
- **nuxeo-webengine**: Services and framework related to WebEngine, the Nuxeo lighweight rendering engine
- **nuxeo-features**: Advanced high-level services, such as audit, imaging, publisher, thumbnails, search
- **nuxeo-dm**: The default Nuxeo Platform application, mostly configuration and UI elements
- **nuxeo-distribution**: This module builds, packages and tests the Nuxeo products.

# Licensing

Most of the source code in the Nuxeo Platform is copyright Nuxeo SA and contributors, and licensed under the GNU Lesser General Public License v2.1.

See and the documentation page [Licenses](http://doc.nuxeo.com/x/gIK7) for details.

# About Nuxeo

Nuxeo dramatically improves how content-based applications are built, managed and deployed, making customers more agile, innovative and successful. Nuxeo provides a next generation, enterprise ready platform for building traditional and cutting-edge content oriented applications. Combining a powerful application development environment with SaaS-based tools and a modular architecture, the Nuxeo Platform and Products provide clear business value to some of the most recognizable brands including Verizon, Electronic Arts, Sharp, FICO, the U.S. Navy, and Boeing. Nuxeo is headquartered in New York and Paris. More information is available at [www.nuxeo.com](http://www.nuxeo.com).
