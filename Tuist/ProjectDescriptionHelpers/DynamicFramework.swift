import ProjectDescription

extension Project {
    public static func dynamicFramework(
        name: String,
        platform: Platform = .iOS,
        packages: [Package] = [],
        infoPlist: InfoPlist = .default,
        deploymentTarget: DeploymentTarget,
        dependencies: [TargetDependency] = [
            .project(target: "ThirdPartyLib", path: "../ThirdPartyLib")
        ]
    ) -> Project {
        return Project(
            name: name,
            packages: packages,
            settings: .settings(base: .codeSign),
            targets: [
                Target(
                    name: name,
                    platform: platform,
                    product: .framework,
                    bundleId: "\(dmsOrganizationName).\(name)",
                    deploymentTarget: deploymentTarget,
                    infoPlist: infoPlist,
                    sources: ["Sources/**"],
                    scripts: [],
                    dependencies: dependencies
                )
            ]
        )
    }
}
