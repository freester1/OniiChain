defmodule OniichainWeb do
    def controller do
      quote do
        use Phoenix.Controller, namespace: OniichainWeb
        import Plug.Conn
        import OniichainWeb.Router.Helpers
        import OniichainWeb.Gettext
      end
    end
  
    def view do
      quote do
        use Phoenix.View, root: "lib/oniichain_web/templates",
                          namespace: OniichainWeb
  
        # Import convenience functions from controllers
        import Phoenix.Controller, only: [get_flash: 2, view_module: 1]
  
        import OniichainWeb.Router.Helpers
        import OniichainWeb.ErrorHelpers
        import OniichainWeb.Gettext
      end
    end
  
    def router do
      quote do
        use Phoenix.Router
        import Plug.Conn
        import Phoenix.Controller
      end
    end
  
    def channel do
      quote do
        use Phoenix.Channel
        import OniichainWeb.Gettext
      end
    end
  
    @doc """
    When used, dispatch to the appropriate controller/view/etc.
    """
    defmacro __using__(which) when is_atom(which) do
      apply(__MODULE__, which, [])
    end
  end
  