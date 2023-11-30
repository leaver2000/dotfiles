format:
	clang-format -i src/my_module/lib/*
	isort src/
	black src/

clean:
	rm -rf src/**/*.so build/ dist/ *.egg-info
	
deep-clean: clean
	rm -rf .coverage .pytest_cache/ .venv/

coverage: clean
	python setup.py build_ext -b src/
	python -m coverage run -m pytest
	python -m coverage report
	gcovr --filter src/

from-scratch: deep-clean
	python3 -m venv .venv/
	. .venv/bin/activate; python -m pip install ".[test]"