import conans.model.requires
from conan import ConanFile
from conan.tools.cmake import CMakeToolchain


class HelloConan(ConanFile):
    settings = 'os', 'compiler', 'build_type', 'arch'
    generators = 'CMakeDeps', 'CMakeToolchain'
    default_options = {'fmt/*:header_only': True, 'spdlog/*:header_only': True}

    def configure(self):
        cmake = CMakeToolchain(self)
        cmake.user_presets_path = None
        if self.settings.get_safe('arch') == 'armv7':
            self.requires = conans.model.requires.Requirements(['fmt/10.0.0', 'sml/1.1.6'])
        else:
            self.requires = conans.model.requires.Requirements(['catch2/3.4.0', 'gtest/1.14.0', 'docopt.cpp/0.6.3',
                                                                'spdlog/1.12.0', 'sml/1.1.8', 'nlohmann_json/3.11.2',
                                                                'boost/1.81.0', 'crowcpp-crow/1.0+5', 'cppzmq/4.9.0',
                                                                'protobuf/3.21.12'])

    def build(self):
        cmake = CMakeToolchain(self)
        cmake.configure()
        cmake.build()
