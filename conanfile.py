import conans.model.requires
from conan import ConanFile
from conan.tools.cmake import CMakeToolchain


class HelloConan(ConanFile):
    settings = 'os', 'compiler', 'build_type', 'arch'
    generators = 'CMakeDeps', 'CMakeToolchain'

    def configure(self):
        if self.settings.get_safe('arch') == 'armv7':
            self.requires = conans.model.requires.Requirements(['fmt/10.1.0'])
            self.default_options = {'fmt/*:header_only': True}
        else:
            self.requires = conans.model.requires.Requirements(['catch2/3.3.2', 'gtest/1.13.0', 'docopt.cpp/0.6.3',
                                                                'fmt/10.1.0', 'sml/1.1.6'])

    def build(self):
        cmake = CMakeToolchain(self)
        cmake.configure()
        cmake.build()
