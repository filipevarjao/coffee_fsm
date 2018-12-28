defmodule CoffeeFsm do
  @behaviour :gen_statem
  use Hw

  @name :coffee_fsm
  def start do
    :gen_statem.start({:local, @name}, __MODULE__, [], [])
  end

  def stop do
    :gen_statem.stop(@name)
  end

  def init([]) do
    Hw.reboot
    Hw.display "Make Your Selection", []
    {:ok, :selection, []}
  end

  def tea, do: :gen_statem.cast(@name, {:selection, :tea, 100})

  def espresso(), do: :gen_statem.cast(@name, {:selection, :espresso, 150})

  def americano(), do: :gen_statem.cast(@name, {:selection, :americano, 150})

  def cappuccino(), do: :gen_statem.cast(@name, {:selection, :cappuccino, 150})

  def pay(coin), do: :gen_statem.cast(@name, {:pay, coin})

  def cancel, do: :gen_statem.cast(@name, :cancel)

  def cup_removed, do: :gen_statem.cast(@name, :cup_removed)

  def selection(:cast, {:selection, type, price}, _loop) do
    Hw.display "Please pay", [price]
    {:next_state, :payment, {type, price, 0}}
  end
  def selection(:cast, {:pay, coin}, loop) do
    Hw.return_change(coin)
    {:next_state, :selection, loop}
  end
  def selection(:cast, _other, loop) do
    {:next_state, :selection, loop}
  end

  def payment(:cast, {:pay, coin}, {type, price, paid}) when coin + paid >= price do
    new_paid = coin + paid
    Hw.display "Preparing Drink.", []
    Hw.return_change(new_paid - price)
    Hw.drop_cup
    Hw.prepare type
    Hw.display "Remove Drink.", []
    {:next_state, :remove, []}
  end
  def payment(:cast, {:pay, coin}, {type, price, paid}) when coin + paid < price do
    new_paid = coin + paid
    Hw.display "Please pay", [price - new_paid]
    {:next_state, :payment, {type, price, new_paid}}
  end
  def payment(:cast, :cancel, {_type, _price, paid}) do
    Hw.display "Make your selection", []
    Hw.return_change(paid)
    {:next_state, :selection, []}
  end
  def payment(:cast, _other, loop), do: {:next_state, :payment, loop}

  def remove(:cast, :cup_removed, loop) do
    Hw.display "Make your selection", []
    {:next_state, :selection, loop}
  end
  def remove(:cast, {:pay, coin}, loop) do
    Hw.return_change coin
    {:next_state, :remove, loop}
  end
  def remove(:cast, _other, loop), do: {:next_state, :remove, loop}

  def code_change(_vsn, state, data, _extra), do: {:ok, state, data}

  def handle_event(:stop, _state, loop) do
    {:stop, :normal, loop}
  end

  def callback_mode, do: :state_functions

  def terminate(_reason, :payment, {_type, _price, paid}) do
    Hw.return_change(paid)
  end
  def terminate(_reason, _state, _loop), do: :ok
end
