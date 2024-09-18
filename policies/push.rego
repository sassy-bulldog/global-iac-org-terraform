package spacelift

# This example Git push policy ignores all changes that are outside a project's
# root. Other than that, it follows the defaults - pushes to the tracked branch
# trigger tracked runs, pushes to all other branches trigger proposed runs, tag
# pushes are ignored.
#
# You can read more about push policies here:
#
# https://docs.spacelift.io/concepts/policy/git-push-policy

track {
  affected
  input.push.branch == input.stack.branch
}

propose { affected }
propose { affected_pr }

ignore  {
    not affected
    not affected_pr
}
ignore  { input.push.tag != "" }
# Here's a definition of an affected file - its path must both:
#
# a) start with the Stack's project root, and;
# b) end with ".tf", indicating that it's a Terraform source file;
affected {
    filepath := input.push.affected_files[_]
    startswith(normalize_path(filepath), normalize_path(input.stack.project_root))
}

affected {
    filepath := input.push.affected_files[_]
    glob_pattern := input.stack.additional_project_globs[_]
    glob.match(glob_pattern, ["/"], normalize_path(filepath))
}

affected_pr {
    filepath := input.pull_request.diff[_]
    startswith(normalize_path(filepath), normalize_path(input.stack.project_root))
}

affected_pr {
    filepath := input.pull_request.diff[_]
    glob_pattern := input.stack.additional_project_globs[_]
    glob.match(glob_pattern, ["/"], normalize_path(filepath))
}

# Helper function to normalize paths by removing leading slashes
normalize_path(path) = trim(path, "/")

# Learn more about sampling policy evaluations here:
#
# https://docs.spacelift.io/concepts/policy#sampling-policy-inputs
sample { true }
