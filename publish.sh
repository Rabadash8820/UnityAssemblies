#!/bin/bash

verifyReleaseNotes() {
    if [ $remindReleaseNotes = false ]; then
        return 0;
    fi

    echo ""
    echo "Verify that CHANGELOG.md and the <releaseNotes/> element of nuspec are up-to-date and committed"
    echo ""
    read -p "Press [Enter] when you're done..."
}

bumpNuGetVersions() {
    echo ""
    echo "Changing package version strings to '$packageVersion' in:"

    findRegex="PackageReference Include=\"Unity3D\""
    replaceTxt="$findRegex Version=\"$packageVersion\" />"

    pkgReadmePath=$cwd/nupkg/readme.txt
    echo "    Sample project file in '$pkgReadmePath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$pkgReadmePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    findRegex="Changelog"
    replaceTxt="$findRegex (currently v$packageVersion)](https://img.shields.io/badge/changelog-v$packageVersion-blue.svg)](./CHANGELOG.md)"

    mainReadmePath=$cwd/README.md
    echo "    Changelog badge at top of '$mainReadmePath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$mainReadmePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    findRegex="<version>"
    replaceTxt="$findRegex$packageVersion</version>"

    nuspecPath=$cwd/nupkg/Unity3D.nuspec
    echo "    Nuspec at '$nuspecPath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$nuspecPath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi
}

bumpUnityVersions() {
    echo "Changing Unity version strings to '$unityVersion' in:"

    findRegex="using Unity .*,"
    replaceTxt="using Unity $unityVersion,"

    echo "    Sample project file description in '$pkgReadmePath'..."
    sed --expression="s|$findRegex|$replaceTxt|" --in-place "$pkgReadmePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    findRegex="<UnityVersion>"
    replaceTxt="$findRegex$unityVersion</UnityVersion>"

    echo "    Sample project file in '$pkgReadmePath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$pkgReadmePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    mainReadmePath=$cwd/README.md
    echo "    Sample project files in '$mainReadmePath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$mainReadmePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    usagePath=$cwd/docs/$docsFolder/usage.md
    echo "    Sample project file at top of '$usagePath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$usagePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    echo ""
    echo "Update the Readme FAQ with which Unity versions this package has been tested."
    echo ""
    read -p "Press [Enter] when you're done..."
}

bumpCurrentYear() {
    currentYear=$(date +'%Y')

    echo ""
    echo "Updating copyright years to '$copyrightStartYear-$currentYear' in:"

    findRegex="[0-9]{4}-[0-9]{4}"
    replaceTxt="$copyrightStartYear-$currentYear"

    nuspecPath=$cwd/nupkg/Unity3D.nuspec
    echo "    Nuspec at '$nuspecPath'..."
    sed --regexp-extended --expression="s|$findRegex|$replaceTxt|" --in-place "$nuspecPath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi
}

checkForNuGet() {
    nuget help &> /dev/null
    if [ $? != 127 ] ; then
        return 1
    else
        echo "nuget.exe not found on PATH. Checking current directory..."
        ./nuget.exe help &> /dev/null
        if [ $? != 127 ] ; then
            return 2
        else
            echo "nuget.exe not found in current directory. Cannot continue."
            return 3
        fi
    fi
}

nugetPack() {
    echo "Creating NuGet package..."
    "$nugetPath" pack "$cwd/nupkg/Unity3D.nuspec"
    return $?
}

nugetSign() {
    echo ""
    if [ -z $signingCertPath ]; then
        echo "Skpping NuGet package signing as no signing certificate path was provided..."
        return 0;
    fi

    echo "Signing NuGet package..."
    "$nugetPath" sign "$nupkgPath" -Timestamper "$timestamper" -CertificatePath "$signingCertPath"
    return $?
}

nugetPush() {
    echo ""
    echo "Publishing NuGet package at '$nupkgPath' to $nugetSource..."
    "$nugetPath" push "$nupkgPath" -Source "$nugetSource" -ApiKey "$nugetSourceApiKey"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    if [ $remindNugetPublish = true ] ; then
        echo ""
        echo "Now sign in to your NuGet source ($nugetSource) and copy over the documentation from the previous package version"
        echo "    This should basically be the contents of the packaged readme.txt file"
        echo "    Also be sure to increment the 'UnityVersion' and 'PackageReference' version strings therein!"
        echo "    If you make any other substantive changes to the documentation, consider backporting them to older versions' documentation also."
        echo ""
        read -p "Press [Enter] when you're done..."
    fi
}

remindTagRelease() {
    if [ $remindTagRelease = false ]; then
        return 0;
    fi

    echo "Add a 'v$packageVersion' tag to the git repo and push it, then create a Release on GitHub for it."
    echo "Don't forget to upload the NuGet package itself to that Release!"
    echo ""
    read -p "Press [Enter] when you're done..."
}

main() {
    cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

    # Set option defaults
    DEFAULT_UNITY_VERSION=2023.1.8f1
    DEFAULT_COPYRIGHT_START_YEAR=2019
    DEFAULT_DOCS_FOLDER=v3
    DEFAULT_TIMESTAMPER=http://timestamp.digicert.com
    DEFAULT_NUGET_SOURCE=nuget.org

    remindReleaseNotes=true
    packageVersion=
    unityVersion=$DEFAULT_UNITY_VERSION
    copyrightStartYear=$DEFAULT_COPYRIGHT_START_YEAR
    docsFolder=$DEFAULT_DOCS_FOLDER
    timestamper=$DEFAULT_TIMESTAMPER
    signPackage=false
    signingCertPath=
    nugetSource=$DEFAULT_NUGET_SOURCE
    nugetSourceApiKey=
    remindNugetPublish=true
    remindTagRelease=true
    pack=true
    isVerbose=false

    # Parse CLI options
    args=$(getopt \
        --name publish \
        --options 'hp:u:c:d:t:n:k:v' \
        --long ' \
            help, \
            remind-release-notes, \
            no-remind-release-notes, \
            package-version:, \
            unity-version:, \
            copyright-start-year:, \
            docs-folder:, \
            timestamper:, \
            signing-cert-path:, \
            nuget-source:, \
            nuget-source-apikey:, \
            remind-nuget-publish, \
            no-remind-nuget-publish, \
            remind-tag-release, \
            no-remind-tag-release, \
            pack, \
            no-pack, \
            verbose, \
        ' -- "$@") || exit
    eval "set -- $args"

    showUsage=false
    if [ $# == 1 ]; then showUsage=true; fi
    while true; do
        case "$1" in
        (-h|--help)
            showUsage=true
            break
            ;;

        (--remind-release-notes)
            remindReleaseNotes=true
            ;;
        (--no-remind-release-notes)
            remindReleaseNotes=false
            ;;

        (-p|--package-version)
            shift
            packageVersion=$1
            ;;

        (-u|--unity-version)
            shift
            unityVersion=$1
            ;;

        (-c|--copyright-start-year)
            shift
            copyrightStartYear=$1
            ;;

        (-d|--docs-folder)
            shift
            docsFolder=$1
            ;;

        (-t|--timestamper)
            shift
            timestamper=$1
            ;;

        (--signing-cert-path)
            shift
            signingCertPath=$1
            ;;

        (-n|--nuget-source)
            shift
            nugetSource=$1
            ;;

        (-k|--nuget-source-apikey)
            shift
            nugetSourceApiKey=$1
            ;;

        (--remind-nuget-publish)
            remindNugetPublish=true
            ;;
        (--no-remind-nuget-publish)
            remindNugetPublish=false
            ;;

        (--remind-tag-release)
            remindTagRelease=true
            ;;
        (--no-remind-tag-release)
            remindTagRelease=false
            ;;

        (--pack)
            pack=true
            ;;
        (--no-pack)
            pack=false
            ;;

        (-v|--verbose)
            isVerbose=true
            ;;

        (--)
            shift
            break
            ;;
        esac
        shift
    done

    if [ $isVerbose == true ]; then
        echo "Options:"
        echo "    remindReleaseNotes: '$remindReleaseNotes'"
        echo "    packageVersion: '$packageVersion'"
        echo "    unityVersion: '$unityVersion'"
        echo "    copyrightStartYear: '$copyrightStartYear'"
        echo "    docsFolder: '$docsFolder'"
        echo "    timestamper: '$timestamper'"
        echo "    signPackage: '$signPackage'"
        echo "    signingCertPath: '$signingCertPath'"
        echo "    nugetSource: '$nugetSource'"
        echo "    nugetSourceApiKey: '$nugetSourceApiKey'"
        echo "    remindNugetPublish: '$remindNugetPublish'"
        echo "    remindTagRelease: '$remindTagRelease'"
        echo "    pack: '$pack'"
        echo "    isVerbose: '$isVerbose'"
    fi

    # Validate CLI options
    if [ $showUsage == false ]; then
        if [ -z $packageVersion ] ; then
            echo "Missing required new semantic version string for the NuGet package. Use the '-p | --package-version' option"
            showUsage=true;
        fi
        if [ -z $nugetSourceApiKey ] && [ $pack == true ]; then
            echo "Missing required API key for NuGet source '$nugetSource'. Use the '-k | --nuget-source-apikey' option"
            showUsage=true;
        fi
    fi

    if [ $showUsage == true ]; then
        echo ""
        echo "Usage: publish <options>"
        echo ""
        echo "    -h, --help"
        echo "                  Display this text and exit"
        echo "    --[no-]remind-release-notes"
        echo "                  Optional. Toggle the reminder to update release notes. Default behavior is to show the reminder."
        echo "    -p, --package-version <packageVersion>"
        echo "                  Required. Version string for this NuGet release. Must be a semantic version string, e.g., '1.2.0' or '2.0.0-rc2'."
        echo "    -u, --unity-version <unityVersion>"
        echo "                  Optional. Latest Unity version to use in documentation. Default is '$DEFAULT_UNITY_VERSION'."
        echo "    -c, --copyright-start-year <copyrightStartYear>"
        echo "                  Optional. Copyright start year to use in documentation. Default is '$DEFAULT_COPYRIGHT_START_YEAR'."
        echo "    -d, --docs-folder <docsFolder>"
        echo "                  Required. Name of folder (under docs/) where documentation Markdown files are stored. Default is '$DEFAULT_DOCS_FOLDER'."
        echo "    -t, --timestamper <timestamper>"
        echo "                  Optional. URL of an RFC 3161 timestamp server for package signing. Default is '$DEFAULT_TIMESTAMPER'."
        echo "    --[no-]sign-package"
        echo "                  Optional. Toggle package signing. Default behavior is to skip package signing."
        echo "    --signing-cert-path <signingCertPath>"
        echo "                  Required if package signing is enabled. File path to the signing certificate (probably a .p12 or .pfx file)."
        echo "    -n, --nuget-source <nugetSource>"
        echo "                  Optional. Target NuGet source for uploading the new NuGet package. Default is '$DEFAULT_NUGET_SOURCE'"
        echo "    -k, --nuget-source-apikey <nugetSourceApiKey>"
        echo "                  Required. API key to use when uploading the new package release to the NuGet source."
        echo "    --[no-]remind-nuget-publish"
        echo "                  Optional. Toggle the reminder to update the NuGet package's page on the source site. Default behavior is to show the reminder."
        echo "    --[no-]remind-tag-release"
        echo "                  Optional. Toggle the reminder to push a new git tag for this NuGet release. Default behavior is to show the reminder."
        echo "    --[no-]pack"
        echo "                  Optional. Toggle whether the NuGet package is packed and published. Default behavior is to proceed with packing/publishing."
        echo "    -v, --verbose"
        echo "                  Optional. Show verbose output."
        return 1
    fi

    # Make sure user has updated package info
    verifyReleaseNotes && \
    bumpNuGetVersions && \
    bumpUnityVersions && \
    bumpCurrentYear

    echo ""
    echo "Commit the changes to version/year that you and this script just made"
    echo ""
    read -p "Press [Enter] when you're done..."

    # Get the path to nuget.exe
    checkForNuGet
    nugetCode=$?
    nugetPath=nuget
    if [ "$nugetCode" = "3" ] ; then
        return 1
    elif [ "$nugetCode" = "2" ] ; then
        nugetPath="./nuget.exe"
    fi

    if [ $pack == false ] ; then
        return 0
    fi

    # Create the NuGet package
    nugetPack
    if [ $? != 0 ]; then return 1; fi
    nupkgPath="$cwd/Unity3D.$packageVersion.nupkg"

    # Sign and push the NuGet package
    nugetSign && \
    nugetPush
    errNum=$?
    if [ $errNum != 0 ] ; then
        echo ""
        echo "Publish completed with error code: $errNum"
        return 1
    fi

    # Remind user what to do after publishing, if necessary
    remindTagRelease

    echo ""
    echo "Publish complete!"
}

main $@
