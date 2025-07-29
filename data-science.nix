{ pkgs, ... }:
{
  # Data Science and Research Tools Configuration
  # Includes R, Jupyter, Python scientific computing stack, and related tools

  environment.systemPackages = with pkgs; [
    # R Environment
    R                          # R statistical computing language
    rWrapper                   # R with commonly used packages
    
    # Jupyter Ecosystem
    jupyter                    # Complete Jupyter environment
    jupyter-all                # Jupyter with all kernels and extensions
    
    # Python Data Science Stack
    python312                  # Latest Python
    python312Packages.jupyter
    python312Packages.jupyterlab
    python312Packages.pandas
    python312Packages.numpy
    python312Packages.matplotlib
    python312Packages.seaborn
    python312Packages.scikit-learn
    python312Packages.requests
    python312Packages.plotly
    
    # Additional Kernels for Jupyter
    gophernotes               # Go kernel for Jupyter
    iruby                     # Ruby kernel for Jupyter
    
    # Data Processing Tools
    jq                        # JSON processor
    yq                        # YAML processor
    csvkit                    # CSV toolkit
    
    # Visualization and Analysis
    gnuplot                   # Plotting program
    graphviz                  # Graph visualization
  ];

  # Configure environment variables for R
  environment.variables = {
    R_LIBS_USER = "$HOME/.local/lib/R/library";
  };

  # Create R library directory structure
  system.activationScripts.r-setup.text = ''
    echo "Setting up R environment..."
    mkdir -p /Users/elw/.local/lib/R/library
    echo "R library directory created"
  '';
}
