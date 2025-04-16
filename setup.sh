#!/bin/bash

# Function to execute and log commands
run_command() {
    # Print a header for the task
    echo "============================================================================"
    echo -e "\t\t\t\t$1" # Task Name
    echo "============================================================================"
    echo

    # Running the command
    # Using eval to correctly handle commands with spaces or special characters like pipes
    eval "$2" # Task Command

    # Capture the exit code of the command
    local exit_code=$?

    # Logging success or error based on the exit code
    if [[ $exit_code -eq 0 ]]; then
        # Print success message in green
        echo -e "\n\n\033[1;32mSUCCESS: $1 completed successfully.\033[0m\n\n"
    else
        # Print error message in red
        echo -e "\n\n\033[1;31mERROR: $1 failed with exit code $exit_code\033[0m\n\n"
        # Optional: exit the script if a task fails
        # exit $exit_code
    fi

    # Return the exit code of the command
    return $exit_code
}

# Associative array mapping task names to commands
declare -A tasks=(
    ["Package Installation"]="./scripts/installer.sh"
    ["Rust Setup"]="./scripts/rust.sh"
    ["Anaconda Installer"]="./scripts/anaconda.sh"
    ["Oh My ZSH"]="./scripts/zsh.sh"
    ["Populating Configs"]="ls -d */ | grep -v scripts | xargs stow"
    ["Tmux Plugin Manager"]="./scripts/tmux.sh"
    ["Powerline Setup"]="./scripts/powerline.sh"
    ["Neovim Setup"]="./scripts/nvim.sh"
)

# Define the explicit order in which tasks should run
ordered_tasks=(
    "Package Installation"
    "Rust Setup"
    "Anaconda Installer"
    "Oh My ZSH"
    "Populating Configs"
    "Powerline Setup"
    "Tmux Plugin Manager"
    "Neovim Setup"
)

# Iterate through the tasks in the defined order
for task_name in "${ordered_tasks[@]}"; do
    # Get the command associated with the task name
    command="${tasks[$task_name]}"
    # Run the command using the run_command function
    run_command "$task_name" "$command"
done

echo "All tasks processed."

# # Tmux Setup
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#
# # Oh My ZSH
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# rm $HOME/{.zshrc}
#
#
# # Populating configs
# ls -d */ | grep -v scripts | xargs stow
#
# env "$POWERLINE_CONFIG_COMMAND" tmux setup
# powerline-config tmux setup
