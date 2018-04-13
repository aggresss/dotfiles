#include <iostream>

using namespace std;

struct ListNode
{
    int value;
    ListNode *next;
};

void ReversePrint(ListNode *pHead) //递归实现逆序打印（不改变链表结构）
{
    if (pHead != NULL)
    {
        if (pHead->next != NULL)
            ReversePrint(pHead->next);
        cout << pHead->value << " ";
    }
}

ListNode *ReverseList1(ListNode *pHead) //头插法（改变链表结构）
{
    if (pHead == NULL)
        return NULL;
    ListNode *p = pHead->next;
    ListNode *newHead = pHead;
    while (p != NULL)
    {                          //将p结点移到链表最前方
        pHead->next = p->next; //头结点指向p的下一个结点
        p->next = newHead;     //p插入链表最前方
        newHead = p;           //链表新头结点更新为p
        p = pHead->next;       //处理下一个结点，该结点位于头结点后
    }
    return newHead;
}

ListNode *ReverseList2(ListNode *pHead) //依次改变指针方向（改变链表结构）
{
    ListNode *prev = NULL;
    ListNode *next = NULL;
    while (pHead != NULL)
    {
        next = pHead->next; //保存剩余链表
        pHead->next = prev; //断开剩余链表头结点pHead，指向pre
        prev = pHead;       //pre更新
        pHead = next;       //head更新
    }
    return prev;
}

int main() //主函数
{
    int n;
    cout << endl
         << "请输入链表元素个数: " << endl;
    cin >> n; //输入元素个数
    ListNode *head = NULL;
    ListNode *p = NULL;
    ListNode *q = NULL;
    cout << endl
         << "请依次输入链表元素: " << endl;
    for (int i = 0; i < n; i++) //分配内存，依次输入元素
    {
        q = new ListNode;
        cin >> q->value;
        if (head == NULL)
        {
            head = q;
            p = head;
        }
        else
        {
            p->next = q;
            p = p->next;
        }
    }
    if (head == NULL)
        return 0;
    p->next = NULL;
    //验证
    cout << "递归逆序打印: " << endl;
    ReversePrint(head);
    cout << endl
         << "头插法反转链表: " << endl;
    ListNode *reverseHead;
    reverseHead = ReverseList1(head);
    p = reverseHead;
    while (p != NULL)
    {
        cout << p->value << " ";
        p = p->next;
    }
    cout << endl
         << "改变指针方向反转链表（将链表再次反转）: " << endl;
    p = ReverseList2(reverseHead); //改变指针方向反转链表
    while (p != NULL)
    {
        cout << p->value << " ";
        q = p;
        p = p->next;
        delete q; //释放内存
    }
    cout << endl;
    return 0;
}