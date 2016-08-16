#include <string>
#include <iostream>
#include <cstdlib>
#include "map"
#include "list"

using namespace std;
map <string, int> symbol_table;

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
			return symbol_table[temp];
		}
};


class Equal: public Expression{
	public:
		Expression* left_expr;
		Expression* right_expr;

		Equal(Expression *left_expr, Expression *right_expr){
			this->left_expr = left_expr;
			this->right_expr = right_expr;
		}

		int evaluate() {
			if (left_expr->evaluate() == right_expr->evaluate())
				return 1;
			else 
				return 0;
		}
};

class LessThan: public Expression{
	public:
		Expression* left_expr;
		Expression* right_expr;

		LessThan(Expression *left_expr, Expression *right_expr){
			this->left_expr = left_expr;
			this->right_expr = right_expr;
		}

		int evaluate() {
			if (left_expr->evaluate() < right_expr->evaluate())
				return 1;
			else 
				return 0;
		}
};

class GreaterThan: public Expression{
	public:
		Expression* left_expr;
		Expression* right_expr;

		GreaterThan(Expression *left_expr, Expression *right_expr){
			this->left_expr = left_expr;
			this->right_expr = right_expr;
		}

		int evaluate() {
			if (left_expr->evaluate() > right_expr->evaluate())
				return 1;
			else 
				return 0;
		}
};

class LessEqual: public Expression{
	public:
		Expression* left_expr;
		Expression* right_expr;

		LessEqual(Expression *left_expr, Expression *right_expr){
			this->left_expr = left_expr;
			this->right_expr = right_expr;
		}

		int evaluate() {
			if (left_expr->evaluate() <= right_expr->evaluate())
				return 1;
			else 
				return 0;
		}
};

class GreaterEqual: public Expression{
	public:
		Expression* left_expr;
		Expression* right_expr;

		GreaterEqual(Expression *left_expr, Expression *right_expr){
			this->left_expr = left_expr;
			this->right_expr = right_expr;
		}

		int evaluate() {
			if (left_expr->evaluate() >= right_expr->evaluate())
				return 1;
			else 
				return 0;
		}
};

class NotEqual: public Expression {
	public:
		Expression* left_expr;
		Expression* right_expr;

		NotEqual(Expression *left_expr, Expression *right_expr){
			this->left_expr = left_expr;
			this->right_expr = right_expr;
		}

		int evaluate() {
			if (left_expr->evaluate() != right_expr->evaluate())
				return 1;
			else 
				return 0;
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


class Else: public Statement{
	public:
		list<Statement*> elseStatementList;
		Else(list<Statement*> elseStatementList) {
			this->elseStatementList =elseStatementList;
		}
		void evaluate() {
			for (std::list<Statement*>::iterator it=elseStatementList.begin(); it != elseStatementList.end(); ++it)
    			(*it)->evaluate();

		}
};

class If: public Statement{
	public:
		list<Statement*> ifStatementList;
		Expression* condition;
		Statement* else_statement;
		If(Expression* condition, list<Statement*> ifStatementList, Statement* else_statement){
			this->condition = condition;
			this->else_statement = else_statement;
			this->ifStatementList = ifStatementList;
		}

		void evaluate() {
			if(condition->evaluate())
				for (std::list<Statement*>::iterator it=ifStatementList.begin(); it != ifStatementList.end(); ++it)
    				(*it)->evaluate();
    		else 
    			else_statement->evaluate();
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
			symbol_table[temp] = expr->evaluate();
		}
};	