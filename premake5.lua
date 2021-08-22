workspace "project"
    startproject "project"
    architecture "x64"

    configurations
    {
        "debug",
        "release"
    }

tdir = "bin/%{cfg.system}-%{cfg.buildcfg}-%{cfg.architecture}/%{prj.name}"
odir = "bin-int/%{cfg.system}-%{cfg.buildcfg}-%{cfg.architecture}/%{prj.name}"

project "project"
    location "project"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"

    targetdir(tdir)
    objdir(odir)
    debugdir("data")

    files
    {
        "%{prj.name}/include/**.h",
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    sysincludedirs
    {
        "vendor/src",
        "vendor/include",
        "%{prj.name}/vendor",
    }

    includedirs
    {
        "%{prj.name}/include",
    }

	postbuildcommands
	{
		"call python ../tools/_postbuild.py project=%{prj.name}",
		"{COPY} %{prj.name}.build.meta ../" .. tdir,
	}

    filter "system:windows"
        systemversion "latest"

        files
        {
            "%{prj.name}/vendor/**.natvis",
        }

        links
        {
            "vendor/lib/spdlog/spdlog"
        }

        defines
        {
            "PS_WIN"
        }

        postbuildcommands
        {
            "{COPY} ../vendor/bin/*.dll ../" .. tdir,
        }

        debugdir(tdir)

    filter "system:linux"
        links
        {
            "spdlog"
        }

        defines
        {
            "PS_LINUX"
        }

    filter "configurations:debug"
        runtime "Debug"
        symbols "on"

        defines
        {
            "PS_DEBUG"
        }

    filter "configurations:release"
        runtime "Release"
        symbols "off"
        optimize "on"

		defines
        {
            "PS_RELEASE"
        }
