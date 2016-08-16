#include <string>
#include <iostream>
#include <cstdlib>
#include "map"
using namespace std;
map <string, int> table_symbol;

class Expression {
	
	public:
		virtual int evaluate() = 0;

};

class AddExpr : public Expression {
	public: 
		Expression* left_expr;
		Expression* right_expr;

		AddExpr(Expression* left_expr, Expression* right_expr){
			this->left_expr = left_expr;
			this->right_expr = right_expr;
		}

		int evaluate(){
			return left_expr->evaluate() + right_expr->evaluate();
		} 
};

class MultExpr : public Expression {
	public: 
		Expression* left_expr;
		Expression* right_expr;

		MultExpr(Expression* left_expr, Expression* right_expr){
			this->left_expr = left_expr;
			this->right_expr = right_expr;
		}

		int evaluate(){
			return left_expr->evaluate() * right_expr->evaluate();
		}
};


class NumExpr: public Expression {
	public:
		int num;
		NumExpr(int value) {
			num = value;
		}

		int evaluate (){
			return num;
		}
};

class IDExpr: public Expression {
	public:
		const char* value;
		IDExpr (const char* value){
			this->value = value;
		}

		int evaluate() {
			string temp(value);
			return table_symbol[temp];
		}
};

class Statement {
	public: 
		virtual void evaluate() = 0; 
};

class Print: public Statement{
	public:
		Expression* expr;
		Print(Expression *expr){
			this->expr = expr;
		}

		void evaluate(){
			cout<<expr->evaluate()<<endl;
		}
};

class Assignment: public Statement{
	public:
		Expression* expr;
		const char* id;
		Assignment(const char* id, Expression *expr){
			this->expr = expr;
			this->id = id;
		}

		void evaluate() {
			string temp(id);
			table_symbol[temp] = expr->evaluate();
		}
};