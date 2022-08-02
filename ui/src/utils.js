const curry = (f) => {
	return (a) => {
		return (b) => {
      return f(a, b);
    };
  };
}
