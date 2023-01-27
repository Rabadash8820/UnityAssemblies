#!/bin/bash

verifyReleaseNotes() {
    echo ""
    echo "Verify that CHANGELOG.md and the <releaseNotes/> element of nuspec are up-to-date"
    echo ""
    read -p "Press [Enter] when you're done..."
}

bumpVersions() {
    echo ""

    # Get new version strings from user
    newPkgVersion=
    prompt="Enter the new package version (such as '1.0.0-rc1'): "
    read -p "$prompt" newPkgVersion
    while [ -z "$newPkgVersion" ] ; do
        echo "Package version string cannot be empty."
        read -p "$prompt" newPkgVersion
    done

    newUnityVersion=
    prompt="Enter the latest Unity version (such as '2020.1.8f1'): "
    read -p "$prompt" newUnityVersion
    while [ -z "$newUnityVersion" ] ; do
        echo "Unity version string cannot be empty."
        read -p "$prompt" newUnityVersion
    done

    # Update package version strings to the provided one
    echo ""
    echo "Changing package version strings to '$newPkgVersion' in:"

    findRegex="PackageReference Include=\"Unity3D\""
    replaceTxt="$findRegex Version=\"$newPkgVersion\" />"

    pkgReadmePath=$cwd/nupkg/readme.txt
    echo "    Sample project file in '$pkgReadmePath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$pkgReadmePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    mainReadmePath=$cwd/README.md
    echo "    Sample project file at top of '$mainReadmePath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$mainReadmePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    findRegex="<version>"
    replaceTxt="$findRegex$newPkgVersion</version>"

    nuspecPath=$cwd/nupkg/Unity3D.nuspec
    echo "    Nuspec at '$nuspecPath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$nuspecPath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    # Update Unity version strings to the provided one
    echo "Changing Unity version strings to '$newUnityVersion' in:"

    findRegex="using Unity .*,"
    replaceTxt="using Unity $newUnityVersion,"

    echo "    Sample project file description in '$pkgReadmePath'..."
    sed --expression="s|$findRegex|$replaceTxt|" --in-place "$pkgReadmePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    findRegex="<UnityVersion>"
    replaceTxt="$findRegex$newUnityVersion</UnityVersion>"

    echo "    Sample project file in '$pkgReadmePath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$pkgReadmePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    mainReadmePath=$cwd/README.md
    echo "    Sample project files in '$mainReadmePath'..."
    sed --expression="s|$findRegex.*|$replaceTxt|" --in-place "$mainReadmePath"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi
}

bumpCurrentYear() {
    defaultCopyrightStartYear=2019
    echo ""
    read -p "Enter the 'start year' of the copyright for this package (or hit [ENTER] to use '$defaultCopyrightStartYear'): " copyrightStartYear
    if [ -z "$copyrightStartYear" ]; then copyrightStartYear=$defaultCopyrightStartYear; fi

    currentYear=$(date +'%Y')

    echo ""
    echo "Updating current year to '$currentYear' in:"

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
    echo ""
    echo "Creating NuGet package..."
    "$nugetPath" pack "$cwd/nupkg/Unity3D.nuspec"
    return $?
}

nugetSign() {
    defaultTimestamper="http://timestamp.digicert.com"
    echo ""
    read -p "Enter the URL of an RFC 3161 timestamp server (or hit [ENTER] to use '$defaultTimestamper'): " timestamper
    if [ -z "$timestamper" ]; then timestamper=$defaultTimestamper; fi

    certPrompt="Enter the file path to the certificate to be used while signing the package (probably a .p12 or .pfx file), or [ENTER] to skip signing (not recommended!): "
    read -p "$certPrompt" certPath
    if [ -z "$certPath" ]; then
        echo "Certificate path empty. Skipping signing (may have to hit [ENTER] again for some reason)..."
        return 0
    fi

    echo ""
    echo "Signing NuGet package..."
    "$nugetPath" sign "$nupkgPath" -Timestamper "$timestamper" -CertificatePath "$certPath"
    return $?
}

nugetPush() {
    read derp  # This hacky piece of sh*t is just here to catch an [Enter]; who knows where it is coming from...

    defaultNuGetSource="nuget.org"
    echo ""
    read -p "Enter the URL of the NuGet source (or hit [Enter] to use '$defaultNuGetSource'): " nugetSource
    if [ -z "$nugetSource" ]; then nugetSource=$defaultNuGetSource; fi

    keyPrompt="Enter the API key for the NuGet source: "
    read -p "$keyPrompt" sourceApiKey
    while [ -z "$sourceApiKey" ] ; do
        echo "API key cannot be empty."
        read -p "$keyPrompt" sourceApiKey
    done

    echo ""
    echo "Publishing NuGet package to nuget.org..."
    "$nugetPath" push "$nupkgPath" -Source "$nugetSource" -ApiKey "$sourceApiKey"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    if [ "$nugetSource" = "nuget.org" ] ; then
        echo ""
        echo "Now sign in to nuget.org, and copy over the documentation from the previous package version"
        echo "    This should basically be the contents of the packaged readme.txt file"
        echo "    Also be sure to increment the UnityVersion and PackageReference version strings therein!"
        echo ""
        read -p "Press [Enter] when you're done..."
    fi
}

remindTagRelease() {
    echo ""
    echo "Don't forget to add a tag to the git repo and create a Release on GitHub!"
    echo ""
    read -p "Press [Enter] when you're done..."
}

main() {
    cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

    # Make sure user has updated package info
    verifyReleaseNotes && \
    bumpVersions && \
    bumpCurrentYear

    echo ""
    echo "Commit the changes to version/year that this script just made"
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

    # Create the NuGet package
    nugetPack
    if [ $? != 0 ]; then return 1; fi
    nupkgPath="$cwd/Unity3D.$newPkgVersion.nupkg"

    # Sign and push the NuGet package
    nugetSign && nugetPush
    errNum=$?
    if [ $errNum != 0 ] ; then
        echo ""
        echo "Publish completed with error code: $errNum"
        return 1
    fi

    # Remind user what to do after publishing
    remindTagRelease

    echo ""
    echo "Publish complete!"
}

main $@
