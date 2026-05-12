def systolic_model(inputs, weights, y_prev=0, flush_cycles=4):
    N = len(weights)

    x_reg = [0] * N   # slice x_out registers
    y_reg = [0] * N   # slice y_out registers

    results = []
    first_cycle = True

    total_cycles = len(inputs) + flush_cycles

    for t in range(total_cycles):
        # apply input or zero during flush
        x_in_ext = inputs[t] if t < len(inputs) else 0

        # construct buses from old state
        x_bus = x_reg + [x_in_ext]
        y_bus = ([y_prev] if first_cycle else [0]) + y_reg

        # compute next registered values
        next_x = [0] * N
        next_y = [0] * N

        for i in range(N):
            next_x[i] = x_bus[i + 1]
            next_y[i] = y_bus[i] + weights[i] * x_reg[i]

        # update  registers
        x_reg = next_x
        y_reg = next_y
        first_cycle = False

        # output from final slice
        results.append(y_reg[N - 1])

    return results


if __name__ == "__main__":
    W = [1, -2, 3]

    # CASE 1
    print("\nCASE 1: Yprev = 0")
    X1 = [5, -3, 2, 1]
    print(systolic_model(X1, W, y_prev=0, flush_cycles=4))

    # CASE 2
    print("\nCASE 2: Yprev=+10")
    X2 = [4, -1, 3]
    print(systolic_model(X2, W, y_prev=10, flush_cycles=4))

    # CASE 3
    print("\nCASE 3: Interleaving")
    stream1 = [1, 2, 3, 4]
    stream2 = [-1, -2, -3, -4]
    X3 = [v for pair in zip(stream1, stream2) for v in pair]
    print(systolic_model(X3, W, y_prev=0, flush_cycles=6))
