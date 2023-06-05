workspace "ng2react" "A tool that converts AngularJS components to React using OpenAI API" {
    !docs ./arc42
    !identifiers hierarchical
    model {
        openAi = softwareSystem "GPT-4" "OpenAI API" "AI"

        ng2react = softwareSystem "AngularJS to React" "Software System" {
            filesystem = container "File System" "Where the user's project files exist" "Native" "datastore"

            cli_wrapper = container "@ng2react/cli" "Command line interface for ng2react" "stdio" {
                !include ng2react-core.dsl
            }

            IDE = container "Generic IDE" "Integrated Development Environment" "Native" {
                ng2react_api = component "Ng2React API" "Native bridge to Node CLI" "Native" {
                    this -> cli_wrapper.ng2react_core "Makes API calls" "stdio"
                }
                ide_plugin = component "IDE Extension" "IDE Specific Implementation" "Native" {
                    this -> ng2react_api "Uses" "stdio"
                    this -> filesystem "Read/Write"
                }
            }

            vscode = container "VSCode" "JavaScript IDE" {
                !include ng2react-core.dsl
                ide_plugin = component "IDE Plugin" "IDE Extension" "JavaScript" {
                    this -> ng2react_core "Uses" "JavaScript API"
                    this -> filesystem "Read/Write"
                }
            }
        }

        ide_user = person "User" "AngularJS/React developer who wants to convert AngularJS components to React" {
            this -> ng2react.IDE.ide_plugin "Uses"
            this -> ng2react.VSCode.ide_plugin "Uses"
        }

        deploymentEnvironment "Live" {
            deploymentNode "Developer Laptop" "" "Microsoft Windows 10 or Apple macOS" {
                deploymentNode "IDE" "" "An integrated development environment with ng2react plugin support" {
                    ideWithPlugin = containerInstance ng2react.IDE
                }
            }
        }
    }

    views {
        systemContext ng2react "SystemContext" {
            include *
            autoLayout
        }

        container ng2react "SoftwareSystem_Generic" {
            include *
            exclude ng2react.vscode
            autoLayout lr
        }

        container ng2react "SoftwareSystem_VSCode" {
            include *
            exclude ng2react.IDE ng2react.cli_wrapper
            autoLayout lr
        }

        component ng2react.IDE "Generic_IDE" {
            include *
            autoLayout lr
        }

        component ng2react.cli_wrapper "AngularJS2React_CLI" {
            include *
            autoLayout lr
        }

        component ng2react.vscode "VSCode_IDE" {
            include *
            autoLayout lr
        }

        deployment ng2react "Live" {
            include *
            autoLayout lr
            description "An example development deployment scenario for the Internet Banking System."
        }

        dynamic ng2react "ScanProject" {
            title "User converts AngularJS component to React"
            ide_user -> ng2react.IDE "Opens AngularJS project inside IDE"
            ng2react.IDE -> ng2react.cli_wrapper "Sends files for analysis"
            ng2react.cli_wrapper -> ng2react.IDE "Returns list of convertable components"
            ng2react.IDE -> ide_user "Displays list of convertable components"
            autoLayout
        }

        dynamic ng2react {
            title "User converts AngularJS component to React"
            ide_user -> ng2react.IDE "Selects component for conversion"
            ng2react.IDE -> ng2react.cli_wrapper "Sends component reference"
            ng2react.cli_wrapper -> openAi "Sends generated prompt"
            ng2react.cli_wrapper -> ng2react.IDE "Returns Markdown, JSX, and original prompt"
            ng2react.IDE -> ide_user "Displays markdown response with save options"
            autoLayout lr
        }

        theme default

        styles {
            element "External" {
                background #aaaaaa
            }

            element "Proposed" {
                background #b7e1cd

            }

            element "AI" {
                background #aaaaaa
                shape Robot
            }

            element "datastore" {
                //                    shape <Box|RoundedBox|Circle|Ellipse|Hexagon|Cylinder|Pipe|Person|Robot|Folder|WebBrowser|MobileDevicePortrait|MobileDeviceLandscape|Component>
                shape Cylinder
                //                    shape Folder
                //                    icon <file|url>
                //                    width <integer>
                //                    height <integer>
                //                    background <#rrggbb|color name>
                //                    color <#rrggbb|color name>
                //                    colour <#rrggbb|color name>
                //                    stroke <#rrggbb|color name>
                //                    strokeWidth <integer: 1-10>
                //                    fontSize <integer>
                //                    border <solid|dashed|dotted>
                //                    opacity <integer: 0-100>
                //                    metadata <true|false>
                //                    description <true|false>
                //                    properties {
                //                        name value
                //                    }
            }

        }
    }
}