import os

from conan import ConanFile
from conan.tools.cmake import CMakeToolchain


class HelloConan(ConanFile):
    settings = 'os', 'compiler', 'build_type', 'arch'
    generators = 'CMakeDeps', 'CMakeToolchain'
    default_options = {'fmt/*:header_only': True, 'spdlog/*:header_only': True, 'qt/*:with_fontconfig': False}

    def requirements(self):
        if self.settings.get_safe('arch') == 'armv7':
            self.requires('fmt/11.1.3')
            self.requires('sml/1.1.11')
            return

        self.requires('catch2/3.8.0')
        self.requires('gtest/1.15.0')
        self.requires('docopt.cpp/0.6.3')
        self.requires('spdlog/1.15.0')
        if os.getenv("CONFIGURE_QT") == '1':
            self.requires('qt/6.7.3')
        else:
            self.requires('sml/1.1.11')
            self.requires('nlohmann_json/3.11.3')
            self.requires('boost/1.87.0')
            self.requires('crowcpp-crow/1.2.0')
            self.requires('cppzmq/4.10.0')
            self.requires('protobuf/5.29.3')

    def configure(self):
        cmake = CMakeToolchain(self)
        cmake.user_presets_path = None

    def build(self):
        cmake = CMakeToolchain(self)
        cmake.configure()
        cmake.build()
